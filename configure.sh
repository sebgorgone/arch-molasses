#!/usr/bin/env bash

echo 'syncing system packages (arch-molasses/software + arch-molasses/driver-software)'

source "$HOME/arch-molasses/software"
source "$HOME/arch-molasses/driver-software"
source "$HOME/arch-molasses/symlink-map"

for pkg in "${packages[@]}"; do
  echo "Updating $pkg…"
  sudo pacman -S --needed --noconfirm "$pkg"
done

set_symlink() {
  local TARGET="$1"
  local SOURCE="$2"

  if [ -z "$TARGET" ] || [ -z "$SOURCE" ]; then
    echo "[ !!! USAGE ] set-symlink <target> <source>"
    return 1
  fi

  if [ -e "$TARGET" ] || [ -L "$TARGET" ]; then
    echo "[WARNING] removing existing location: $TARGET"
    sudo rm -rf "$TARGET"
  fi

  sudo mkdir -p "$(dirname "$TARGET")"
  echo "CREATING SYMLINK: $TARGET -> $SOURCE"
  sudo ln -sf "$SOURCE" "$TARGET"

  echo "CREATED LINK FOR $TARGET"
}

for link in "${symlinks[@]}"; do
  SOURCE=$(echo "$link" | awk '{print $1}')
  TARGET=$(echo "$link" | awk '{print $2}')
  set_symlink "$TARGET" "$SOURCE"
done

#BASHDIR="$HOME/.local/share/bash"
#SOURCE_BASHDIR="$HOME/arch-molasses/bash"

#set_symlink $BASHDIR $SOURCE_BASHDIR
