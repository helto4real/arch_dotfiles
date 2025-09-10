#!/bin/bash

# Ett enkelt script för att slå på eller av en WireGuard-anslutning.
# Kräver att `wireguard-tools` är installerat.

# --- Konfiguration ---
# Namnet på ditt WireGuard-interface. Detta motsvarar filnamnet i /etc/wireguard/.
# Till exempel, 'wg0' för /etc/wireguard/wg0.conf.
INTERFACE="wg0"

# --- Scriptet börjar här ---

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

# Kontrollera om WireGuard-interfacet är aktivt.
wg show "$INTERFACE" &> /dev/null

if [ $? -eq 0 ]; then
  # Interfacet är uppe, så vi stänger ner det.
  send_notification "WireGuard" "Stänger ner anslutningen till '$INTERFACE'..."
  wg-quick down "$INTERFACE"
  if [ $? -eq 0 ]; then
    send_notification "WireGuard" "Anslutningen är nere."
  else
    send_notification "WireGuard" "Misslyckades att stänga ner anslutningen." "critical"
  fi
else
  # Interfacet är nere, så vi startar det.
  send_notification "WireGuard" "Ansluter till '$INTERFACE'..."
  wg-quick up "$INTERFACE"
  if [ $? -eq 0 ]; then
    send_notification "WireGuard" "Ansluten till WireGuard."
  else
    send_notification "WireGuard" "Det gick inte att ansluta. Kontrollera din konfigurationsfil: /etc/wireguard/$INTERFACE.conf" "critical"
  fi
fi
