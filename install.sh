#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -eEo pipefail

DOTFILES_REPO="https://github.com/Charlos60/dotfiles"
DOTFILES_PATH="$HOME/.dotfiles"

echo ""
echo "╔══════════════════════════════════════════════╗"
echo "║         Carlos Dotfiles Installer            ║"
echo "║   CachyOS + Omarchy + Configuración personal ║"
echo "╚══════════════════════════════════════════════╝"
echo ""

# ─── Comprobaciones previas ──────────────────────────────────────────
if [ "$EUID" -eq 0 ]; then
  echo "ERROR: No ejecutes este script como root." >&2
  exit 1
fi

if ! command -v pacman &>/dev/null; then
  echo "ERROR: Este script requiere CachyOS / Arch Linux (pacman no encontrado)." >&2
  exit 1
fi

echo "▶ Verificando dependencias básicas..."
sudo pacman -Sy --noconfirm --needed git curl base-devel 2>/dev/null

# ─── Paso 1: Instalar yay (AUR helper) si no está ───────────────────
if ! command -v yay &>/dev/null; then
  echo "▶ Instalando yay (AUR helper)..."
  git clone https://aur.archlinux.org/yay.git /tmp/yay-install
  cd /tmp/yay-install && makepkg -si --noconfirm && cd -
  rm -rf /tmp/yay-install
fi

# ─── Paso 2: Instalar Omarchy si no está ─────────────────────────────
if [ ! -d "$HOME/.local/share/omarchy" ]; then
  echo ""
  echo "▶ Omarchy no detectado. Instalando omarchy-on-cachyos..."
  echo "  Clonando omarchy-on-cachyos..."
  git clone https://github.com/mroboff/omarchy-on-cachyos.git /tmp/omarchy-on-cachyos
  cd /tmp/omarchy-on-cachyos
  bash bin/omarchy-on-cachyos.sh
  cd -
  rm -rf /tmp/omarchy-on-cachyos
else
  echo "▶ Omarchy ya instalado, saltando..."
fi

# ─── Paso 3: Clonar dotfiles ──────────────────────────────────────────
echo ""
echo "▶ Clonando dotfiles personales..."
if [ -d "$DOTFILES_PATH" ]; then
  echo "  Actualizando repositorio existente..."
  git -C "$DOTFILES_PATH" pull
else
  git clone "$DOTFILES_REPO" "$DOTFILES_PATH"
fi

# ─── Paso 4: Aplicar configuraciones ─────────────────────────────────
source "$DOTFILES_PATH/setup/apply-configs.sh"

# ─── Paso 5: Instalar paquetes extra ─────────────────────────────────
source "$DOTFILES_PATH/setup/install-packages.sh"

# ─── Finalizado ──────────────────────────────────────────────────────
echo ""
echo "╔══════════════════════════════════════════════╗"
echo "║   ¡Instalación completada exitosamente!      ║"
echo "║   Reinicia la sesión para aplicar cambios.   ║"
echo "╚══════════════════════════════════════════════╝"
echo ""
