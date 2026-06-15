#!/bin/sh

set -eu

if pidof hyprlock >/dev/null 2>&1; then
    exit 0
fi

exec hyprlock
