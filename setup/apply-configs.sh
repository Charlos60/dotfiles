#!/bin/bash
# Aplica todas las configuraciones personales encima de Omarchy

DOTFILES_PATH="${DOTFILES_PATH:-$HOME/.dotfiles}"
CONFIG_SRC="$DOTFILES_PATH/config"
HOME_SRC="$DOTFILES_PATH/home"

echo ""
echo "▶ Aplicando configuraciones personales..."

# ─── Configs de ~/.config/ ────────────────────────────────────────────
mkdir -p "$HOME/.config"

for item in "$CONFIG_SRC"/*/; do
  name=$(basename "$item")
  dest="$HOME/.config/$name"
  if [ -d "$item" ]; then
    echo "  → ~/.config/$name"
    mkdir -p "$dest"
    cp -r "$item"/. "$dest/"
  fi
done

# Archivos de config sueltos
for file in chromium-flags.conf starship.toml pavucontrol.ini mimeapps.list xdg-terminals.list; do
  if [ -f "$CONFIG_SRC/$file" ]; then
    echo "  → ~/.config/$file"
    cp "$CONFIG_SRC/$file" "$HOME/.config/$file"
  fi
done

# ─── Dotfiles del home ────────────────────────────────────────────────
echo ""
echo "▶ Aplicando dotfiles del home..."
for dotfile in "$HOME_SRC"/.[^.]*; do
  name=$(basename "$dotfile")
  echo "  → ~/$name"
  cp "$dotfile" "$HOME/$name"
done

echo ""
echo "✓ Configuraciones aplicadas."
