#!/usr/bin/env sh
set -e

multiple="$1"
directory="$2"
save="$3"
path="$4"
out="$5"
debug="$6"

[ "$debug" = "1" ] && set -x

cmd="yazi"
termcmd="${TERMCMD:-ghostty --class=file_chooser -e}"

run_yazi() {
  command="$termcmd $cmd"

  for arg in "$@"; do
    escaped=$(printf "%s" "$arg" | sed 's/"/\\"/g')
    command="$command \"$escaped\""
  done

  sh -c "$command"
}

if [ "$save" = "1" ]; then
  # Chrome/portal SaveFile expects a full file path. Only an explicit
  # chooser selection should save; quitting Yazi should cancel the download.
  selected_file="$out.selected"

  suggested_name="$(basename -- "$path")"

  if [ -z "$suggested_name" ] || [ "$suggested_name" = "." ] || [ "$suggested_name" = "/" ]; then
    suggested_name="download"
  fi

  if [ -d "$path" ]; then
    start_dir="$path"
  else
    start_dir="$(dirname -- "$path")"
  fi

  if [ ! -d "$start_dir" ]; then
    start_dir="${HOME}/Downloads"
  fi

  run_yazi --chooser-file="$selected_file" "$start_dir"

  selected=""

  if [ -s "$selected_file" ]; then
    selected="$(head -n 1 "$selected_file")"
  fi

  rm -f "$selected_file"

  if [ -z "$selected" ]; then
    exit 1
  fi

  if [ -d "$selected" ]; then
    printf '%s/%s\n' "$selected" "$suggested_name" >"$out"
  else
    printf '%s\n' "$selected" >"$out"
  fi

elif [ "$directory" = "1" ]; then
  run_yazi --chooser-file="$out" --cwd-file="$out.1" "$path"

  if [ ! -s "$out" ] && [ -s "$out.1" ]; then
    cat "$out.1" >"$out"
  fi

  rm -f "$out.1"

elif [ "$multiple" = "1" ]; then
  run_yazi --chooser-file="$out" "$path"

else
  run_yazi --chooser-file="$out" "$path"
fi
