#!/usr/bin/env bash
set -e

if [[ $EUID -ne 0 ]]; then
    exec sudo "$0" "$@"
fi

TOR_UID=$(id -u tor 2>/dev/null || id -u debian-tor)

TRANS_PORT=9040
DNS_PORT=5353
CHAIN="TOR"

is_enabled() {
    iptables -t nat -L OUTPUT | grep -q "$CHAIN"
}

enable_tor() {
    echo "[+] Starting Tor..."
    systemctl start tor

    echo "[+] Creating TOR chain..."
    iptables -t nat -N $CHAIN 2>/dev/null || true

    iptables -t nat -F $CHAIN

    # tor bypass
    iptables -t nat -A $CHAIN -m owner --uid-owner $TOR_UID -j RETURN

    # local bypass
    iptables -t nat -A $CHAIN -d 127.0.0.0/8 -j RETURN
    iptables -t nat -A $CHAIN -d 10.0.0.0/8 -j RETURN
    iptables -t nat -A $CHAIN -d 172.16.0.0/12 -j RETURN
    iptables -t nat -A $CHAIN -d 192.168.0.0/16 -j RETURN

    # DNS
    iptables -t nat -A $CHAIN -p udp --dport 53 -j REDIRECT --to-ports $DNS_PORT

    # TCP
    iptables -t nat -A $CHAIN -p tcp --syn -j REDIRECT --to-ports $TRANS_PORT

    # hook chain
    iptables -t nat -A OUTPUT -j $CHAIN

    echo "[+] Tor routing enabled"
}

disable_tor() {
    echo "[-] Removing TOR rules..."

    iptables -t nat -D OUTPUT -j $CHAIN 2>/dev/null || true
    iptables -t nat -F $CHAIN 2>/dev/null || true
    iptables -t nat -X $CHAIN 2>/dev/null || true

    echo "[-] Stopping Tor..."
    systemctl stop tor

    echo "[-] Tor routing disabled"
}

if is_enabled; then
    disable_tor
else
    enable_tor
fi
