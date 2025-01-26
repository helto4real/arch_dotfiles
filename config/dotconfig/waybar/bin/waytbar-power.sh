# shows a power menu for Hyprland

# Define the options for the power menu
options="Shutdown\nReboot\nLogout\nSuspend\nHibernate"

# Show the menu using rofi
selected_option=$(echo -e "$options" | rofi -dmenu -i -p "Power Menu:")

# Execute the selected option
case $selected_option in
    Shutdown)
        systemctl poweroff
        ;;
    Reboot)
        systemctl reboot
        ;;
    Logout)
        hyprctl dispatch exit
        ;;
    Suspend)
        systemctl suspend
        ;;
    Hibernate)
        systemctl hibernate
        ;;
    *)
        ;;
esac


