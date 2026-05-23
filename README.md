# Carlos Dotfiles

Configuración personal de escritorio basada en **CachyOS + Omarchy (Hyprland)**.

## Instalación en equipo nuevo

### Pre-requisitos

1. Instala **CachyOS** (https://cachyos.org)
2. Durante la instalación elige el entorno de escritorio **sin** entorno gráfico (CLI), o cualquiera que prefieras — el script reemplazará la configuración.

### Un solo comando

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/Charlos60/dotfiles/main/install.sh)"
```

El script hace automáticamente:
1. Instala `yay` (AUR helper) si no está
2. Instala **omarchy-on-cachyos** (Hyprland + toda la base de Omarchy)
3. Clona este repositorio
4. Aplica todas tus configuraciones personales
5. Instala los paquetes adicionales

---

## Estructura del repositorio

```
dotfiles/
├── install.sh                  ← Script de instalación principal
├── setup/
│   ├── apply-configs.sh        ← Aplica configs a ~/.config/
│   └── install-packages.sh     ← Instala paquetes
├── config/                     ← Contenido de ~/.config/
│   ├── hypr/                   ← Hyprland (monitores, bindings, input)
│   ├── waybar/                 ← Barra de estado
│   ├── omarchy/                ← Tema, extensiones, branding
│   ├── fish/                   ← Fish shell
│   ├── nvim/                   ← Neovim
│   ├── ghostty/                ← Terminal Ghostty
│   ├── foot/                   ← Terminal Foot
│   ├── alacritty/              ← Terminal Alacritty
│   ├── walker/                 ← Launcher
│   ├── mako/                   ← Notificaciones
│   ├── btop/                   ← Monitor del sistema
│   └── ...                     ← Resto de apps
├── home/                       ← Dotfiles del home (~/.bashrc, etc.)
└── packages/
    ├── all-explicit.txt        ← Todos los paquetes instalados
    ├── pacman-official.txt     ← Paquetes de repos oficiales
    └── aur.txt                 ← Paquetes del AUR
```

## Actualizar el repositorio

Cuando hagas cambios en tus configs, ejecuta:

```bash
~/.dotfiles/update.sh
```

O manualmente:

```bash
cd ~/.dotfiles
# Copia los configs actuales
rsync -av --delete ~/.config/hypr/ config/hypr/
rsync -av --delete ~/.config/waybar/ config/waybar/
rsync -av --delete ~/.config/omarchy/ config/omarchy/
# ... etc
git add -A && git commit -m "Update configs" && git push
```

## Configuración de hardware

- **Monitores**: `config/hypr/monitors.conf` — configurado para DP-1 (1920x1080) + DVI-I-1 (1680x1050)
- **Teclado**: Layout español (`es`), `compose:caps`
- **Touchpad**: clickfinger habilitado

Edita `config/hypr/monitors.conf` para adaptar al hardware del nuevo equipo.
