# shows a power menu for Hyprland

daily_note="/home/thhel/.config/scripts/edit_daily_note.sh"
toggle_vpn="/home/thhel/.config/scripts/toggle_wireguard_wrapper.sh"
toggle_vpn_usa="/home/thhel/.config/scripts/toggle_wireguard_wrapper_usa.sh"
toggle_hdr="/home/thhel/.config/scripts/toggle_hdr.sh"
toggle_comfyui="/home/thhel/.config/scripts/toggle_comfyui.sh"

# Define the options for the power menu
options="1. Daily Note\n2. Toggle VPN\n3. Toggle VPN USA\n4. Btop\n5. Toggle HDR\n6. Toggle ComfyUI\nReboot\nLogout\nSuspend\nHibernate"

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
"3. Toggle VPN USA")
  $toggle_vpn_usa
  ;;
"4. Btop")
  btop
  ;;
"5. Toggle HDR")
  $toggle_hdr
  ;;
"6. Toggle ComfyUI")
  $toggle_comfyui
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
*) ;;
esac
