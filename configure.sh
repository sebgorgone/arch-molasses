#!/usr/bin/env bash

echo 'syncing system packageed (arch-molasses/software + arch-molasses/driver-software)'

source $HOME/arch-molasses/software
source $HOME/arch-molasses/driver-software

for pkg in "${packages[@]}"; do
  echo "Updating $pkg…"
  sudo pacman -S --needed --noconfirm "$pkg"
done

BASHDIR="$HOME/.local/share/bash"
SOURCE_BASHDIR="$HOME/arch-molasses/bash"

set_symlink() {}
