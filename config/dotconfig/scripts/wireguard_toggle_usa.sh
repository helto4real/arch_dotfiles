#!/bin/zsh
# INTERFACE="sdl85"
# if ip link show $INTERFACE >/dev/null 2>&1; then
# echo "Wireguard is running. Stopping wireguard..."
# sudo wg-quick down /home/thhel/.config/.secrets/wireguard/sdl85.conf
# sudo resolvconf -u
# echo "Wireguard stopped successfully."
# else
# echo "Wireguard is not running. Starting wireguard..."
# sudo resolvconf -u
# sudo wg-quick up /home/thhel/.config/.secrets/wireguard/sdl85.conf
# echo "Wireguard started successfully."
# fi

# Hämta original användarens UID (fungerar för både sudo och pkexec)
if [ -n "$PKEXEC_UID" ]; then
  ORIGINAL_UID="$PKEXEC_UID"
elif [ -n "$SUDO_UID" ]; then
  ORIGINAL_UID="$SUDO_UID"
else
  send_notification "Kunde inte hitta original användarens UID. Kör med sudo eller pkexec."
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

#If wireguard is running, stop it else start it
if ip link show "nyc71" >/dev/null 2>&1; then
    send_notification "WireGuard" "Wireguard is running. Stopping wireguard..."
    sudo wg-quick down /home/thhel/.config/.secrets/wireguard/nyc71.conf
    sudo resolvconf -u
    send_notification "WireGuard" "Wireguard stopped successfully"
else
    send_notification "WireGuard" "Wireguard is not running. Starting wireguard..."
    sudo resolvconf -u
    sudo wg-quick up /home/thhel/.config/.secrets/wireguard/nyc71.conf
    send_notification "WireGuard" "Wireguard started successfully connectied to New York server"
fi

# # Define the interface name
# INTERFACE="sdl85"
#
# # If the wireguard interface exists, stop it. Otherwise, start it.
# if ip link show $INTERFACE >/dev/null 2>&1; then
#     echo "Wireguard interface '$INTERFACE' is up. Stopping..."
#     sudo wg-quick down $INTERFACE
#     echo "Wireguard stopped successfully."
# else
#     echo "Wireguard interface '$INTERFACE' is not up. Starting..."
#     # The path may still be needed if the conf isn't in /etc/wireguard/
#     sudo resolvconf -u
#
#     sudo wg-quick up /home/thhel/.config/.secrets/wireguard/sdl85.conf
#     echo "Wireguard started successfully."
# fi
# #!/bin/zsh

# # --- Configuration ---
# # Use a variable for the config file to make it easy to change.
# WIREGUARD_CONF="/home/thhel/.config/.secrets/wireguard/sdl85.conf"
# # Extract the interface name from the filename for checking the link.
# # This assumes your interface is named 'sdl85' (without the .conf)
# INTERFACE=$(basename "$WIREGUARD_CONF" .conf)
# # ---------------------
#
# # Check if the network interface exists
# if ip link show $INTERFACE >/dev/null 2>&1; then
#     echo "Wireguard interface '$INTERFACE' is up. Stopping..."
#     # 1. Use the FULL PATH for the 'down' command.
#     sudo wg-quick down "$WIREGUARD_CONF"
#
#     # 2. Manually restore DNS settings. This is the crucial fix for no internet.
#     sudo resolvconf -u
#
#     echo "Wireguard stopped and network restored."
# else
#     echo "Wireguard interface '$INTERFACE' is not up. Starting..."
#     # Update DNS before starting to prevent conflicts.
#     sudo resolvconf -u
#     sudo wg-quick up "$WIREGUARD_CONF"
#     echo "Wireguard started successfully."
# fi
