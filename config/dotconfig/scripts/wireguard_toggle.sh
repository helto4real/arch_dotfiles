#!/bin/zsh

INTERFACE="sdl85"
WIREGUARD_CONF="/home/thhel/.config/.secrets/wireguard/${INTERFACE}.conf"
PREFERRED_LAN_INTERFACES=("enp129s0" "wlan0")
VERIFY_HOSTS=("api.openai.com" "chatgpt.com")
WIREGUARD_DNS_PATTERN="46\\.227\\.67\\.134|192\\.165\\.9\\.158|2a07:a880|2001:67c:750"
ENABLE_NM_RECONNECT_FALLBACK="${ENABLE_NM_RECONNECT_FALLBACK:-0}"

# Hämta original användarens UID (fungerar för både sudo och pkexec)
if [ -n "$PKEXEC_UID" ]; then
  ORIGINAL_UID="$PKEXEC_UID"
elif [ -n "$SUDO_UID" ]; then
  ORIGINAL_UID="$SUDO_UID"
else
  echo "Kunde inte hitta original användarens UID. Kör med sudo eller pkexec." >&2
  exit 1
fi

# Hämta användarnamnet från UID
ORIGINAL_USER=$(getent passwd "$ORIGINAL_UID" | cut -d: -f1)

# Sätt DBUS_SESSION_BUS_ADDRESS för användarens session (modern systemd-stil)
DBUS_ADDR="unix:path=/run/user/$ORIGINAL_UID/bus"
# Funktion för att skicka notifikation som original användaren
send_notification() {
  local title="$1"
  local message="$2"
  local urgency="${3:-normal}"  # Standard: normal, kan vara low, normal, critical

  sudo -u "$ORIGINAL_USER" XDG_RUNTIME_DIR="/run/user/$ORIGINAL_UID" DBUS_SESSION_BUS_ADDRESS="$DBUS_ADDR" notify-send -u "$urgency" "$title" "$message"
}

log() {
  printf '[wireguard-toggle:%s] %s\n' "$INTERFACE" "$*" >&2
}

print_dns_status() {
  local label="$1"
  log "DNS status ${label}:"
  resolvectl dns 2>/dev/null >&2 || log "resolvectl dns failed"
}

clear_wireguard_resolvconf_state() {
  local resolvconf_name
  local resolvconf_names=("$INTERFACE" "tun.${INTERFACE}" "wg.${INTERFACE}")

  if ! command -v resolvconf >/dev/null 2>&1; then
    log "resolvconf unavailable; skipping stale WireGuard DNS cleanup"
    return 0
  fi

  for resolvconf_name in "${resolvconf_names[@]}"; do
    log "Clearing resolvconf state for ${resolvconf_name}"
    if ! resolvconf -f -d "$resolvconf_name" >/dev/null 2>&1; then
      log "resolvconf delete failed for ${resolvconf_name}; removing stale runtime files"
      remove_resolvconf_runtime_key "$resolvconf_name"
    fi
  done

  clear_resolvconf_error_if_empty
}

remove_resolvconf_runtime_key() {
  local resolvconf_name="$1"
  local resolvconf_base="/run/resolvconf"
  local resolvconf_path resolvconf_dir

  for resolvconf_path in \
    "${resolvconf_base}/keys/${resolvconf_name}" \
    "${resolvconf_base}/private/${resolvconf_name}" \
    "${resolvconf_base}/nosearch/${resolvconf_name}" \
    "${resolvconf_base}/deprecated/${resolvconf_name}"; do
    [ -e "$resolvconf_path" ] && rm -f -- "$resolvconf_path"
  done

  for resolvconf_dir in "${resolvconf_base}/metrics" "${resolvconf_base}/exclusive"; do
    [ -d "$resolvconf_dir" ] || continue
    find "$resolvconf_dir" -maxdepth 1 -type f -name "* ${resolvconf_name}" -delete 2>/dev/null || true
  done
}

clear_resolvconf_error_if_empty() {
  local resolvconf_base="/run/resolvconf"

  [ -d "${resolvconf_base}/keys" ] || return 0
  if ! find "${resolvconf_base}/keys" -mindepth 1 -maxdepth 1 -print -quit 2>/dev/null | grep -q .; then
    [ -e "${resolvconf_base}/error" ] && rm -f -- "${resolvconf_base}/error"
  fi
}

active_lan_interfaces() {
  local seen="" iface type state preferred

  for preferred in "${PREFERRED_LAN_INTERFACES[@]}"; do
    if nmcli -t -f DEVICE,TYPE,STATE device 2>/dev/null | grep -Fxq "${preferred}:ethernet:connected" \
      || nmcli -t -f DEVICE,TYPE,STATE device 2>/dev/null | grep -Fxq "${preferred}:wifi:connected"; then
      printf '%s\n' "$preferred"
      seen="${seen} ${preferred} "
    fi
  done

  nmcli -t -f DEVICE,TYPE,STATE device 2>/dev/null | while IFS=: read -r iface type state; do
    if [ "$state" = "connected" ] && { [ "$type" = "ethernet" ] || [ "$type" = "wifi" ]; } && [[ "$seen" != *" ${iface} "* ]]; then
      printf '%s\n' "$iface"
    fi
  done
}

reapply_active_lan_interfaces() {
  local iface

  for iface in $(active_lan_interfaces); do
    log "Reapplying NetworkManager config on ${iface}"
    if nmcli device reapply "$iface"; then
      continue
    fi

    log "nmcli reapply failed on ${iface}"
    if [ "$ENABLE_NM_RECONNECT_FALLBACK" = "1" ]; then
      log "Reconnect fallback enabled for ${iface}"
      nmcli device disconnect "$iface" && nmcli device connect "$iface"
    else
      log "Reconnect fallback disabled for ${iface}"
    fi
  done
}

lan_dns_restored() {
  local iface dns_line dns_values

  for iface in $(active_lan_interfaces); do
    dns_line="$(resolvectl dns "$iface" 2>/dev/null)"
    dns_values="$(printf '%s\n' "$dns_line" | sed 's/^[^:]*:[[:space:]]*//')"
    if printf '%s\n' "$dns_values" | grep -Eq '([0-9]{1,3}\.){3}[0-9]{1,3}|[0-9a-fA-F:]{2,}' \
      && ! printf '%s\n' "$dns_values" | grep -Eiq "$WIREGUARD_DNS_PATTERN"; then
      log "LAN DNS detected on ${iface}: ${dns_line}"
      return 0
    fi
  done

  return 1
}

wait_for_lan_dns() {
  local attempt

  for attempt in {1..10}; do
    if lan_dns_restored; then
      return 0
    fi
    sleep 0.5
  done

  return 1
}

verify_dns_resolution() {
  local host

  for host in "${VERIFY_HOSTS[@]}"; do
    log "Resolving ${host}"
    if ! resolvectl query "$host" >/dev/null; then
      log "DNS verification failed for ${host}"
      return 1
    fi
  done

  return 0
}

recover_dns_after_wireguard_down() {
  print_dns_status "before recovery"
  clear_wireguard_resolvconf_state

  log "Flushing systemd-resolved cache"
  resolvectl flush-caches || log "resolvectl flush-caches failed"

  reapply_active_lan_interfaces

  if ! wait_for_lan_dns; then
    print_dns_status "after failed LAN DNS wait"
    return 1
  fi

  print_dns_status "after recovery"
  verify_dns_resolution
}

make_wg_quick_config_without_dns() {
  local tmp_dir="$1"
  local tmp_conf="${tmp_dir}/${INTERFACE}.conf"

  awk '!/^[[:space:]]*DNS[[:space:]]*=/' "$WIREGUARD_CONF" >"$tmp_conf" || return 1
  chmod 600 "$tmp_conf"
  printf '%s\n' "$tmp_conf"
}

wireguard_dns_servers() {
  awk -F= '
    /^[[:space:]]*DNS[[:space:]]*=/ {
      dns = $2
      gsub(/^[[:space:]]+|[[:space:]]+$/, "", dns)
      gsub(/[[:space:]]*,[[:space:]]*/, " ", dns)
      print dns
    }
  ' "$WIREGUARD_CONF"
}

configure_wireguard_resolved_dns() {
  local dns_servers

  dns_servers="$(wireguard_dns_servers | tr '\n' ' ')"
  if ! printf '%s' "$dns_servers" | grep -Eq '[^[:space:]]'; then
    log "No WireGuard DNS entries found in ${WIREGUARD_CONF}"
    return 0
  fi

  log "Applying systemd-resolved DNS on ${INTERFACE}: ${dns_servers}"
  resolvectl dns "$INTERFACE" ${=dns_servers} || return 1
  resolvectl domain "$INTERFACE" "~." || return 1
  resolvectl default-route "$INTERFACE" yes || log "resolvectl default-route failed for ${INTERFACE}"
}

run_wg_quick_down() {
  local tmp_dir tmp_conf wg_log wg_status

  tmp_dir="$(mktemp -d "/tmp/wg-quick-${INTERFACE}.XXXXXX")" || return 1
  tmp_conf="$(make_wg_quick_config_without_dns "$tmp_dir")" || {
    rm -rf "$tmp_dir"
    return 1
  }
  wg_log="${tmp_dir}/wg-quick-down.log"

  wg-quick down "$tmp_conf" >"$wg_log" 2>&1
  wg_status=$?
  if [ -s "$wg_log" ]; then
    sed 's/^/[wg-quick] /' "$wg_log" >&2
  fi

  rm -rf "$tmp_dir"
  return "$wg_status"
}

run_wg_quick_up() {
  local tmp_dir tmp_conf wg_log wg_status

  tmp_dir="$(mktemp -d "/tmp/wg-quick-${INTERFACE}.XXXXXX")" || return 1
  tmp_conf="$(make_wg_quick_config_without_dns "$tmp_dir")" || {
    rm -rf "$tmp_dir"
    return 1
  }
  wg_log="${tmp_dir}/wg-quick-up.log"

  wg-quick up "$tmp_conf" >"$wg_log" 2>&1
  wg_status=$?
  if [ "$wg_status" -eq 0 ]; then
    if [ -s "$wg_log" ]; then
      sed 's/^/[wg-quick] /' "$wg_log" >&2
    fi
    if ! configure_wireguard_resolved_dns; then
      log "Failed to apply WireGuard DNS; tearing down ${INTERFACE}"
      wg-quick down "$tmp_conf" >/dev/null 2>&1 || ip link delete dev "$INTERFACE" 2>/dev/null
      rm -rf "$tmp_dir"
      return 1
    fi
    rm -rf "$tmp_dir"
    return 0
  fi

  log "wg-quick up failed with exit ${wg_status}; last output:"
  tail -n 20 "$wg_log" | sed 's/^/[wg-quick] /' >&2
  rm -rf "$tmp_dir"
  return "$wg_status"
}

# If wireguard is running, stop it else start it
if ip link show "$INTERFACE" >/dev/null 2>&1; then
    send_notification "WireGuard" "WireGuard is running. Stopping WireGuard..."
    log "Stopping WireGuard interface ${INTERFACE}"
    print_dns_status "before wg-quick down"
    clear_wireguard_resolvconf_state

    if ! run_wg_quick_down; then
      log "wg-quick down failed"
      send_notification "WireGuard" "WireGuard stop failed" "critical"
      exit 1
    fi

    clear_wireguard_resolvconf_state
    if recover_dns_after_wireguard_down; then
      send_notification "WireGuard" "WireGuard stopped; DNS restored"
    else
      send_notification "WireGuard" "WireGuard stopped; DNS verification failed" "normal"
      exit 2
    fi
else
    send_notification "WireGuard" "WireGuard is not running. Starting WireGuard..."
    log "Starting WireGuard interface ${INTERFACE}"
    print_dns_status "before wg-quick up"
    clear_wireguard_resolvconf_state

    if run_wg_quick_up; then
      print_dns_status "after wg-quick up"
      send_notification "WireGuard" "WireGuard started successfully"
    else
      log "wg-quick up failed; cleaning resolver state"
      clear_wireguard_resolvconf_state
      recover_dns_after_wireguard_down || log "DNS recovery after failed start did not fully verify"
      send_notification "WireGuard" "WireGuard start failed" "critical"
      exit 1
    fi
fi
