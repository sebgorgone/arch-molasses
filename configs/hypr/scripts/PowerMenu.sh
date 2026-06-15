#!/bin/sh

set -eu

options='Lock
Logout
Suspend
Reboot
Shutdown'

if command -v walker >/dev/null 2>&1; then
    choice=$(printf '%s\n' "$options" | walker -d -p 'Power' --minheight 5 --width 220)
elif command -v wofi >/dev/null 2>&1; then
    choice=$(printf '%s\n' "$options" | wofi --show dmenu --prompt 'Power' --lines 5 --width 220)
elif command -v rofi >/dev/null 2>&1; then
    choice=$(printf '%s\n' "$options" | rofi -dmenu -p 'Power')
else
    echo 'PowerMenu.sh requires walker, wofi, or rofi' >&2
    exit 1
fi

case "$choice" in
    Lock)
        exec "$HOME/arch-molasses/configs/hypr/scripts/LockScreen.sh"
        ;;
    Logout)
        exec hyprctl dispatch exit
        ;;
    Suspend)
        exec sh -lc 'loginctl lock-session && systemctl suspend'
        ;;
    Reboot)
        exec systemctl reboot
        ;;
    Shutdown)
        exec systemctl poweroff
        ;;
esac
