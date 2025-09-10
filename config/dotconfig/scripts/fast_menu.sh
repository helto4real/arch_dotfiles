# shows a power menu for Hyprland

daily_note="/home/thhel/.config/scripts/edit_daily_note.sh"
toggle_vpn="/home/thhel/.config/scripts/toggle_wireguard_wrapper.sh"

# Define the options for the power menu
options="1. Daily Note\n2. Toggle VPN\n3. Btop\nReboot\nLogout\nSuspend\nHibernate"

# Show the menu using rofi
selected_option=$(echo -e "$options" | rofi -dmenu -i -p "Fast menu:")

# Execute the selected option
case $selected_option in
    "1. Daily Note")
        $daily_note
        ;;
    "2. Toggle VPN")
         $toggle_vpn
        ;;
    "3. Btop")
         btop
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
