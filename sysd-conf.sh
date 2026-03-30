#!/usr/bin/env bash
set -e

# allow running as user
if [ "$EUID" -ne 0 ]; then
    SUDO=sudo
else
    SUDO=""
fi

enable() {
    if systemctl list-unit-files | grep -q "^$1"; then
        echo "Enabling $1"
        $SUDO systemctl enable "$1"
    else
        echo "Skipping $1 (not installed)"
    fi
}

enable_user() {
    if systemctl --user list-unit-files | grep -q "^$1"; then
        echo "Enabling user $1"
        systemctl --user enable "$1"
    else
        echo "Skipping user $1"
    fi
}

echo "== enabling system services =="

# display manager
enable sddm.service

# networking (if you're using systemd-networkd)
enable systemd-networkd.service
enable systemd-resolved.service

# ssh
enable sshd.service

# seat management (hyprland without logind fallback)
enable seatd.service

# audio (pipewire stack — usually socket activated but safe)
enable pipewire.service
enable pipewire-pulse.service
enable wireplumber.service

# reflector auto mirror updates
enable reflector.timer

echo "== enabling user services =="

# notifications
enable_user dunst.service || true
enable_user swaync.service || true


echo "done. rebooting.."

sudo reboot now

