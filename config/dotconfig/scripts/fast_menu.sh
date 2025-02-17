# shows a power menu for Hyprland

daily_note="/home/thhel/.config/scripts/edit_daily_note.sh"

# Define the options for the power menu
options="1. Daily Note\nReboot\nLogout\nSuspend\nHibernate"

# Show the menu using rofi
selected_option=$(echo -e "$options" | rofi -dmenu -i -p "Fast menu:")

# Execute the selected option
case $selected_option in
    "1. Daily Note")
        $daily_note
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
