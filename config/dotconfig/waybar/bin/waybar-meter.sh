#!/usr/bin/env bash

set -u

track="#313244"
text="#cdd6f4"
subtext="#a6adc8"
mauve="#cba6f7"
pink="#f5c2e7"
peach="#fab387"
green="#a6e3a1"
red="#f38ba8"
blue="#89b4fa"
sky="#89dceb"

json_escape() {
  local value=${1//\\/\\\\}
  value=${value//\"/\\\"}
  value=${value//$'\n'/\\n}
  printf '%s' "$value"
}

emit() {
  local text_value="$1"
  local class_value="${2:-normal}"
  local tooltip_value="${3:-$text_value}"

  printf '{"text":"%s","class":"%s","tooltip":"%s"}\n' \
    "$(json_escape "$text_value")" \
    "$(json_escape "$class_value")" \
    "$(json_escape "$tooltip_value")"
}

clamp_percent() {
  local value="${1:-0}"
  if (( value < 0 )); then
    printf '0'
  elif (( value > 100 )); then
    printf '100'
  else
    printf '%s' "$value"
  fi
}

bar() {
  local percent
  percent=$(clamp_percent "${1:-0}")
  local fill_color="${2:-$mauve}"
  local glow_color="${3:-$pink}"
  local slots=10
  local filled=$(( (percent + 5) / 10 ))
  local empty=$(( slots - filled ))
  local out=""

  for ((i = 1; i <= filled; i++)); do
    if (( i > filled - 2 )); then
      out+="<span color='$glow_color'>━</span>"
    else
      out+="<span color='$fill_color'>━</span>"
    fi
  done

  for ((i = 1; i <= empty; i++)); do
    out+="<span color='$track'>━</span>"
  done

  printf '%s' "$out"
}

volume() {
  if ! command -v wpctl >/dev/null 2>&1; then
    emit "<span color='$subtext'>VOL n/a</span> $(bar 0 "$track" "$track")" "warning" "wpctl not found"
    return
  fi

  local line muted volume percent icon class
  line=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null || true)

  if [[ -z "$line" ]]; then
    emit "<span color='$subtext'>VOL n/a</span> $(bar 0 "$track" "$track")" "warning" "No default audio sink"
    return
  fi

  muted=false
  [[ "$line" == *"[MUTED]"* ]] && muted=true

  volume=$(awk '{print $2}' <<<"$line")
  percent=$(awk -v v="$volume" 'BEGIN { printf "%d", (v * 100) + 0.5 }')
  percent=$(clamp_percent "$percent")

  if [[ "$muted" == true ]]; then
    icon="󰖁"
    class="muted"
  elif (( percent < 35 )); then
    icon=""
    class="low"
  elif (( percent < 70 )); then
    icon=""
    class="normal"
  else
    icon=""
    class="high"
  fi

  emit "<span color='$peach'>$icon VOL ${percent}%</span> $(bar "$percent" "$peach" "$pink")" "$class" "Volume: ${percent}%"
}

disk() {
  local line used free total free_percent class
  line=$(df -P / 2>/dev/null | awk 'NR == 2 {print $2, $3, $4, $5}' || true)

  if [[ -z "$line" ]]; then
    emit "<span color='$subtext'>ROOT n/a</span> $(bar 0 "$track" "$track")" "warning" "Unable to read / disk usage"
    return
  fi

  read -r total used free _ <<<"$line"
  free_percent=$(awk -v f="$free" -v t="$total" 'BEGIN { if (t > 0) printf "%d", (f / t * 100) + 0.5; else print 0 }')
  free_percent=$(clamp_percent "$free_percent")
  class="normal"
  (( free_percent < 15 )) && class="critical"
  (( free_percent >= 15 && free_percent < 30 )) && class="warning"

  emit "<span color='$green'>ROOT ${free_percent}% FREE</span> $(bar "$free_percent" "$green" "$peach")" "$class" "Root free: ${free_percent}%"
}

temp() {
  local preferred="/sys/class/hwmon/hwmon4/temp1_input"
  local path=""
  local raw temp_c temp_bar class

  if [[ -r "$preferred" ]]; then
    path="$preferred"
  else
    for candidate in /sys/class/hwmon/hwmon*/temp*_input; do
      if [[ -r "$candidate" ]]; then
        path="$candidate"
        break
      fi
    done
  fi

  if [[ -z "$path" ]]; then
    emit "<span color='$subtext'>CPU n/aC</span> $(bar 0 "$track" "$track")" "warning" "No readable hwmon temperature sensor"
    return
  fi

  raw=$(<"$path")
  temp_c=$(( raw / 1000 ))
  temp_bar=$(clamp_percent "$temp_c")
  class="normal"
  (( temp_c >= 80 )) && class="critical"
  (( temp_c >= 65 && temp_c < 80 )) && class="warning"

  emit "<span color='$peach'>CPU ${temp_c}C</span> $(bar "$temp_bar" "$peach" "$red")" "$class" "Temperature: ${temp_c}C (${path})"
}

cpu() {
  local state_file="/tmp/waybar-meter-cpu.stat"
  local line user nice system idle iowait irq softirq steal guest guest_nice
  local idle_all non_idle total prev_idle prev_total diff_idle diff_total usage class

  read -r _ user nice system idle iowait irq softirq steal guest guest_nice < /proc/stat
  idle_all=$(( idle + iowait ))
  non_idle=$(( user + nice + system + irq + softirq + steal ))
  total=$(( idle_all + non_idle ))

  if [[ -r "$state_file" ]]; then
    read -r prev_idle prev_total < "$state_file"
  else
    prev_idle=$idle_all
    prev_total=$total
  fi

  printf '%s %s\n' "$idle_all" "$total" > "$state_file"

  diff_idle=$(( idle_all - prev_idle ))
  diff_total=$(( total - prev_total ))
  if (( diff_total > 0 )); then
    usage=$(( (100 * (diff_total - diff_idle)) / diff_total ))
  else
    usage=0
  fi
  usage=$(clamp_percent "$usage")
  class="normal"
  (( usage >= 85 )) && class="critical"
  (( usage >= 65 && usage < 85 )) && class="warning"

  emit "<span color='$mauve'>CPU ${usage}%</span> $(bar "$usage" "$mauve" "$pink")" "$class" "CPU usage: ${usage}%"
}

memory() {
  local mem_total mem_available mem_used used_g total_g percent class

  mem_total=$(awk '/^MemTotal:/ {print $2}' /proc/meminfo)
  mem_available=$(awk '/^MemAvailable:/ {print $2}' /proc/meminfo)

  if [[ -z "${mem_total:-}" || -z "${mem_available:-}" || "$mem_total" -eq 0 ]]; then
    emit "<span color='$subtext'>RAM n/a</span> $(bar 0 "$track" "$track")" "warning" "Unable to read memory info"
    return
  fi

  mem_used=$(( mem_total - mem_available ))
  percent=$(( (100 * mem_used) / mem_total ))
  percent=$(clamp_percent "$percent")
  used_g=$(awk -v kb="$mem_used" 'BEGIN { printf "%.1f", kb / 1048576 }')
  total_g=$(awk -v kb="$mem_total" 'BEGIN { printf "%.1f", kb / 1048576 }')
  class="normal"
  (( percent >= 85 )) && class="critical"
  (( percent >= 70 && percent < 85 )) && class="warning"

  emit "<span color='$blue'>RAM ${used_g}G/${total_g}G</span> $(bar "$percent" "$blue" "$mauve")" "$class" "Memory: ${percent}% used"
}

case "${1:-}" in
  volume) volume ;;
  disk) disk ;;
  temp | temperature) temp ;;
  cpu) cpu ;;
  memory | mem) memory ;;
  *) emit "<span color='$subtext'>meter?</span> $(bar 0 "$track" "$track")" "warning" "Usage: waybar-meter.sh volume|disk|temp|cpu|memory" ;;
esac
