#!/bin/sh
set -eu

dbus-update-activation-environment --systemd \
  WAYLAND_DISPLAY \
  XDG_CURRENT_DESKTOP \
  XDG_SESSION_TYPE \
  HYPRLAND_INSTANCE_SIGNATURE \
  GTK_USE_PORTAL \
  GDK_DEBUG

systemctl --user start hyprland-session.target
systemctl --user restart xdg-desktop-portal-termfilechooser.service
systemctl --user restart xdg-desktop-portal-hyprland.service
systemctl --user restart xdg-desktop-portal.service
