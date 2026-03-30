#!/usr/bin/env bash
set -e

# use sudo only if not root
if [ "$EUID" -ne 0 ]; then
    SUDO=sudo
else
    SUDO=""
fi

echo "Enabling systemd-networkd + resolved..."
$SUDO systemctl enable systemd-networkd
$SUDO systemctl enable systemd-resolved

echo "Creating DHCP network config..."
$SUDO mkdir -p /etc/systemd/network

$SUDO tee /etc/systemd/network/20-dhcp.network > /dev/null <<EOF
[Match]
Name=en*

[Network]
DHCP=yes
EOF

echo "Linking resolv.conf..."
$SUDO ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf

echo "Starting services..."
$SUDO systemctl start systemd-networkd
$SUDO systemctl start systemd-resolved

echo "Done."
