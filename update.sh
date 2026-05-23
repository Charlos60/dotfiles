#!/bin/bash
# Sincroniza los configs actuales al repositorio dotfiles

set -eEo pipefail

DOTFILES_PATH="${DOTFILES_PATH:-$(dirname "$(realpath "$0")")}"

echo "▶ Sincronizando configuraciones al repositorio..."

# Función para sync un directorio de config
sync_config() {
  local name="$1"
  local src="$HOME/.config/$name"
  local dst="$DOTFILES_PATH/config/$name"
  if [ -e "$src" ]; then
    rsync -av --delete "$src/" "$dst/" 2>/dev/null || cp -r "$src" "$DOTFILES_PATH/config/"
    echo "  ✓ $name"
  fi
}

# Directorios de configuración
for dir in hypr waybar omarchy fish nvim ghostty foot alacritty kitty walker mako \
           btop fastfetch tmux lazygit starship.toml opencode zed aether \
           environment.d autostart systemd uwsm swayosd wiremix wireplumber \
           uv mise elephant voxtype mpv imv xournalpp Typora; do
  sync_config "$dir"
done

# Archivos sueltos en ~/.config/
for file in chromium-flags.conf starship.toml pavucontrol.ini mimeapps.list xdg-terminals.list; do
  if [ -f "$HOME/.config/$file" ]; then
    cp "$HOME/.config/$file" "$DOTFILES_PATH/config/"
    echo "  ✓ $file"
  fi
done

# Dotfiles del home
echo ""
echo "▶ Sincronizando dotfiles del home..."
for f in .bashrc .bash_profile .bash_logout .profile; do
  if [ -f "$HOME/$f" ]; then
    cp "$HOME/$f" "$DOTFILES_PATH/home/"
    echo "  ✓ $f"
  fi
done

# Lista de paquetes actualizada
echo ""
echo "▶ Actualizando lista de paquetes..."
pacman -Qqe > "$DOTFILES_PATH/packages/all-explicit.txt"
pacman -Qqen > "$DOTFILES_PATH/packages/pacman-official.txt"
pacman -Qqem > "$DOTFILES_PATH/packages/aur.txt"
echo "  ✓ Listas de paquetes actualizadas"

# Git commit y push
echo ""
echo "▶ Subiendo cambios a GitHub..."
cd "$DOTFILES_PATH"
git add -A
if git diff --cached --quiet; then
  echo "  No hay cambios nuevos para subir."
else
  git commit -m "Update dotfiles - $(date '+%Y-%m-%d %H:%M')"
  git push
  echo "  ✓ Cambios subidos a GitHub"
fi

echo ""
echo "✓ Repositorio actualizado."
