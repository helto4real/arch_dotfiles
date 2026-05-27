# Hyprland + Yazi as XDG File Picker on Arch Linux

This document describes a working setup for using **Yazi** as the terminal-based file picker on **Hyprland / Arch Linux**, including support for:

- selecting files
- selecting folders
- saving files from applications such as Google Chrome
- using **Ghostty** as the terminal

The important part is that this is not configured directly in Hyprland. Applications such as Chrome use the **XDG Desktop Portal FileChooser** interface. The goal is therefore to route the FileChooser portal to `xdg-desktop-portal-termfilechooser`, which then launches Yazi inside Ghostty.

---

## 1. Required packages

Install the base portal packages, Yazi, and Ghostty:

```sh
sudo pacman -S yazi ghostty xdg-desktop-portal xdg-desktop-portal-hyprland xdg-desktop-portal-gtk
```

Install `xdg-desktop-portal-termfilechooser` from AUR:

```sh
yay -S xdg-desktop-portal-termfilechooser
```

---

## 2. XDG Desktop Portal configuration

Create the portal configuration directory:

```sh
mkdir -p ~/.config/xdg-desktop-portal
```

Create this file:

```sh
nvim ~/.config/xdg-desktop-portal/hyprland-portals.conf
```

Content:

```ini
[preferred]
default=hyprland;gtk
org.freedesktop.impl.portal.FileChooser=termfilechooser
```

This means:

- use the Hyprland portal backend by default
- fall back to GTK where needed
- specifically use `termfilechooser` for file picker dialogs

---

## 3. Configure termfilechooser

Create the config directory:

```sh
mkdir -p ~/.config/xdg-desktop-portal-termfilechooser
```

Create the config file:

```sh
nvim ~/.config/xdg-desktop-portal-termfilechooser/config
```

Working configuration:

```ini
[filechooser]
cmd=/home/YOURUSER/.config/xdg-desktop-portal-termfilechooser/yazi-wrapper.sh
create_help_file=0
default_dir=$HOME/Downloads
env=TERMCMD='ghostty --class=file_chooser -e'
open_mode=suggested
save_mode=suggested
```

Replace `YOURUSER` with your actual Linux username.

Important settings:

```ini
create_help_file=0
save_mode=suggested
```

`create_help_file=1` creates an instruction/helper file for save dialogs. In Chrome, this caused the helper text file itself to be saved instead of the actual downloaded image/file. Setting it to `0` avoids that problem.

---

## 4. Working Yazi wrapper script

Create the wrapper:

```sh
nvim ~/.config/xdg-desktop-portal-termfilechooser/yazi-wrapper.sh
```

Content:

```sh
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
    # Chrome/portal SaveFile expects a FULL FILE PATH, not only a directory.
    #
    # We use Yazi to choose/navigate to a directory, then append the suggested
    # filename from $path.

    selected_file="$out.selected"
    cwd_file="$out.cwd"

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

    run_yazi --chooser-file="$selected_file" --cwd-file="$cwd_file" "$start_dir"

    selected=""

    if [ -s "$selected_file" ]; then
        selected="$(head -n 1 "$selected_file")"
    elif [ -s "$cwd_file" ]; then
        selected="$(cat "$cwd_file")"
    fi

    rm -f "$selected_file" "$cwd_file"

    if [ -z "$selected" ]; then
        exit 1
    fi

    if [ -d "$selected" ]; then
        printf '%s/%s\n' "$selected" "$suggested_name" > "$out"
    else
        # If you explicitly selected an existing file, use that exact file.
        printf '%s\n' "$selected" > "$out"
    fi

elif [ "$directory" = "1" ]; then
    run_yazi --chooser-file="$out" --cwd-file="$out.1" "$path"

    if [ ! -s "$out" ] && [ -s "$out.1" ]; then
        cat "$out.1" > "$out"
    fi

    rm -f "$out.1"

elif [ "$multiple" = "1" ]; then
    run_yazi --chooser-file="$out" "$path"

else
    run_yazi --chooser-file="$out" "$path"
fi
```

Make it executable:

```sh
chmod +x ~/.config/xdg-desktop-portal-termfilechooser/yazi-wrapper.sh
```

---

## 5. How the wrapper works

### File selection

For normal file selection, the wrapper simply starts Yazi with:

```sh
--chooser-file="$out"
```

Yazi writes the selected file path to the output file expected by the portal.

### Folder selection

Folder selection needs an extra fallback:

```sh
--cwd-file="$out.1"
```

This allows this workflow:

1. Navigate into the folder in Yazi.
2. Press `q`.
3. The wrapper uses the current Yazi directory as the selected folder.

### Save file dialogs

This was the tricky part.

Chrome's save dialogs use the portal's `SaveFile` method. That method expects a **full file path**, not only a directory.

So for save mode, the wrapper does this:

1. Starts Yazi in the suggested directory.
2. Lets you navigate to the target folder.
3. Reads the final folder from `--cwd-file`.
4. Appends Chrome's suggested filename.
5. Writes the full path to the portal output file.

Example:

```text
Selected folder:
/home/tomas/Downloads/images

Suggested filename from Chrome:
photo.png

Final path returned to Chrome:
/home/tomas/Downloads/images/photo.png
```

This is why saving images/files from Chrome works correctly.

---

## 6. Restart portal services

After editing config or wrapper scripts, restart the portal services:

```sh
systemctl --user restart xdg-desktop-portal.service
systemctl --user restart xdg-desktop-portal-termfilechooser.service
systemctl --user restart xdg-desktop-portal-hyprland.service 2>/dev/null || true
```

If things still behave strangely, log out of Hyprland and log back in.

---

## 7. Hyprland environment setup

In your Hyprland config, make sure the session environment is imported into systemd/dbus:

```ini
exec-once = dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE HYPRLAND_INSTANCE_SIGNATURE
```

Also make sure these are set:

```ini
env = XDG_CURRENT_DESKTOP,Hyprland
env = XDG_SESSION_TYPE,wayland
```

Check in a terminal:

```sh
echo $XDG_CURRENT_DESKTOP
echo $XDG_SESSION_TYPE
```

Expected output:

```text
Hyprland
wayland
```

---

## 8. Optional Hyprland window rules for Ghostty file picker

Because the wrapper launches Ghostty with:

```sh
ghostty --class=file_chooser -e
```

You can style the file picker window in Hyprland:

```ini
windowrulev2 = float, class:^(file_chooser)$
windowrulev2 = size 1000 700, class:^(file_chooser)$
windowrulev2 = center, class:^(file_chooser)$
```

---

## 9. Google Chrome setup

Chrome may need to be forced to use portals.

Test with a fresh Chrome instance:

```sh
pkill -f chrome
sleep 1

GTK_USE_PORTAL=1 google-chrome-stable \
  --user-data-dir=/tmp/chrome-yazi-test \
  --no-first-run
```

If that works, make it permanent by editing Chrome's desktop file.

Copy it locally:

```sh
mkdir -p ~/.local/share/applications
cp /usr/share/applications/google-chrome.desktop ~/.local/share/applications/
```

Edit it:

```sh
nvim ~/.local/share/applications/google-chrome.desktop
```

Change every `Exec=` line from something like:

```ini
Exec=/usr/bin/google-chrome-stable %U
```

to:

```ini
Exec=env GTK_USE_PORTAL=1 /usr/bin/google-chrome-stable %U
```

Also update incognito or other action `Exec=` lines if present.

Refresh desktop database:

```sh
update-desktop-database ~/.local/share/applications 2>/dev/null || true
```

Fully close Chrome before testing again:

```sh
pkill -f chrome
```

---

## 10. How to use the file picker

### Open/select a file

1. Trigger a file upload/open dialog.
2. Yazi opens in Ghostty.
3. Select the file.
4. Press Enter/open.

### Select a folder

1. Trigger a folder picker.
2. Navigate into the folder in Yazi.
3. Press `q`.

The wrapper returns the current Yazi directory.

### Save image/file from Chrome

1. Choose “Save image as…” or similar in Chrome.
2. Yazi opens in Ghostty.
3. Navigate into the target folder.
4. Press `q`.
5. The wrapper appends Chrome's suggested filename and returns the full save path.

Example:

```text
Navigate to:
/home/tomas/Pictures/wallpapers

Press q.

Chrome saves to:
/home/tomas/Pictures/wallpapers/suggested-image-name.png
```

---

## 11. Tests

### Test normal file selection

```sh
GDK_DEBUG=portals zenity --file-selection
```

### Test folder selection

```sh
GDK_DEBUG=portals zenity --file-selection --directory
```

### Test save file selection

```sh
GDK_DEBUG=portals zenity --file-selection --save --filename="$HOME/Downloads/test-image.png"
```

For the save test:

1. Navigate to the target folder in Yazi.
2. Press `q`.
3. The command should return a full file path ending in `test-image.png`.

---

## 12. Debugging

Watch portal logs:

```sh
journalctl --user -f -u xdg-desktop-portal -u xdg-desktop-portal-termfilechooser
```

If Chrome does not trigger any termfilechooser logs, Chrome is probably not using the portal. Make sure it is started with:

```sh
GTK_USE_PORTAL=1
```

Also make sure Chrome is fully closed before testing, because launching Chrome with a new environment variable may reuse an already-running Chrome process.

Use:

```sh
pkill -f chrome
```

before retesting.

---

## 13. Problem notes and fixes

### Problem: folder selection does not work

Run:

```sh
GDK_DEBUG=portals zenity --file-selection --directory
```

If this returns the correct folder, the wrapper is working and the issue is likely app-specific.

### Problem: Chrome says selected SaveFile is a directory

This means Chrome used `SaveFile`, not directory selection. `SaveFile` expects a full file path.

The working wrapper solves this by appending the suggested filename to the selected folder.

### Problem: saved file contains instruction text instead of the real image/file

This happens when:

```ini
create_help_file=1
```

Fix:

```ini
create_help_file=0
```

### Problem: deleting the helper file makes Chrome not download anything

Do not delete the helper file as a workaround. It can make the portal treat the save operation as cancelled or failed.

The correct fix is to disable helper file creation and return a full save path from the wrapper.

---

## 14. Final known-good setup summary

Portal config:

```ini
[preferred]
default=hyprland;gtk
org.freedesktop.impl.portal.FileChooser=termfilechooser
```

Termfilechooser config:

```ini
[filechooser]
cmd=/home/YOURUSER/.config/xdg-desktop-portal-termfilechooser/yazi-wrapper.sh
create_help_file=0
default_dir=$HOME/Downloads
env=TERMCMD='ghostty --class=file_chooser -e'
open_mode=suggested
save_mode=suggested
```

Save flow:

```text
Chrome SaveFile request
→ termfilechooser
→ Ghostty
→ Yazi
→ navigate to target folder
→ press q
→ wrapper appends suggested filename
→ Chrome receives full file path
→ download succeeds
```

