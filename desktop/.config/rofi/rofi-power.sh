#!/bin/sh

Shutdown_command="systemctl poweroff"
Reboot_command="systemctl reboot"
Logout_command="i3-msg exit"
Hibernate_command="systemctl hibernate"
Suspend_command="systemctl suspend"
Back_command=""

# you can customise the rofi command all you want ...
rofi_command="rofi -theme /home/thhel/.config/rofi/config.rasi"
options=$'Back\nShutdown\nLogout\nReboot\nHibernate\nSuspend' 

# ... because the essential options (-dmenu and -p) are added here
eval \$"$(echo "$options" | $rofi_command -dmenu -p "")_command"
