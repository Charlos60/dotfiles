#!/bin/bash
# Instala paquetes extra instalados manualmente (fuera de Omarchy base)

DOTFILES_PATH="${DOTFILES_PATH:-$HOME/.dotfiles}"
PACKAGES_DIR="$DOTFILES_PATH/packages"

echo ""
echo "▶ Instalando paquetes AUR adicionales..."
if [ -f "$PACKAGES_DIR/aur.txt" ]; then
  # Filtrar paquetes ya instalados
  to_install=()
  while IFS= read -r pkg; do
    if ! pacman -Qq "$pkg" &>/dev/null; then
      to_install+=("$pkg")
    fi
  done < "$PACKAGES_DIR/aur.txt"

  if [ ${#to_install[@]} -gt 0 ]; then
    yay -S --noconfirm --needed "${to_install[@]}" 2>/dev/null || true
  else
    echo "  Todos los paquetes AUR ya están instalados."
  fi
fi

echo ""
echo "▶ Instalando paquetes oficiales adicionales..."
if [ -f "$PACKAGES_DIR/pacman-official.txt" ]; then
  to_install=()
  while IFS= read -r pkg; do
    if ! pacman -Qq "$pkg" &>/dev/null; then
      to_install+=("$pkg")
    fi
  done < "$PACKAGES_DIR/pacman-official.txt"

  if [ ${#to_install[@]} -gt 0 ]; then
    sudo pacman -S --noconfirm --needed "${to_install[@]}" 2>/dev/null || true
  else
    echo "  Todos los paquetes oficiales ya están instalados."
  fi
fi

echo "✓ Paquetes instalados."
