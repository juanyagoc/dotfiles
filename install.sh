#!/usr/bin/env bash
#
# install.sh (AI-generated, human-reviewed)
# Automatic dotfiles installer for macOS (Apple Silicon)
#
# Usage:
#   cd ~/dotfiles
#   ./install.sh
#
# What it does:
#   1. Verifies that you are on macOS Apple Silicon (arm64)
#   2. Installs Homebrew if it doesn't exist
#   3. Installs everything listed in the Brewfile (brew bundle)
#   4. Backs up your current configs before changing anything
#   5. Creates symlinks from .config/* to the dotfiles repo
#   6. Installs Hack Nerd Font
#   7. Synchronizes LazyVim plugins in headless mode
#   8. Clones Powerlevel10k if not already present in oh-my-zsh/custom/themes
#   9. Changes the default shell to zsh if it isn't already
#
set -euo pipefail

# ────────────────────────────────────────────────────────────
# General Configuration
# ────────────────────────────────────────────────────────────
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_SRC="$DOTFILES_DIR/.config"
CONFIG_DST="$HOME/.config"
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
FONTS_DST="$HOME/Library/Fonts"

# Colors for messages
c_info()  { printf "\033[1;34m[INFO]\033[0m %s\n" "$1"; }
c_ok()    { printf "\033[1;32m[ OK ]\033[0m %s\n" "$1"; }
c_warn()  { printf "\033[1;33m[WARN]\033[0m %s\n" "$1"; }
c_err()   { printf "\033[1;31m[ERR ]\033[0m %s\n" "$1"; }

# ────────────────────────────────────────────────────────────
# 1. Platform Check
# ────────────────────────────────────────────────────────────
c_info "Checking platform..."

if [[ "$(uname -s)" != "Darwin" ]]; then
  c_err "This script is intended for macOS only."
  exit 1
fi

if [[ "$(uname -m)" != "arm64" ]]; then
  c_err "This script is intended for Apple Silicon (arm64). Detected: $(uname -m)."
  exit 1
fi

c_ok "macOS Apple Silicon detected."

# ────────────────────────────────────────────────────────────
# 2. Homebrew
# ────────────────────────────────────────────────────────────
if ! command -v brew &>/dev/null; then
  c_info "Homebrew not found. Installing..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
  c_ok "Homebrew installed."
else
  c_ok "Homebrew is already installed."
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# ────────────────────────────────────────────────────────────
# 3. Brewfile
# ────────────────────────────────────────────────────────────
if [[ -f "$DOTFILES_DIR/Brewfile" ]]; then
  c_info "Installing packages from Brewfile (this might take a while)..."
  brew bundle --file="$DOTFILES_DIR/Brewfile"
  c_ok "Homebrew packages installed/updated."
else
  c_warn "Brewfile not found in $DOTFILES_DIR. Skipping this step."
fi

# ────────────────────────────────────────────────────────────
# 4. Safe symlink function with backup
# ────────────────────────────────────────────────────────────
link_item() {
  local src="$1"
  local dst="$2"

  if [[ ! -e "$src" ]]; then
    c_warn "Source does not exist: $src (skipping)"
    return
  fi

  # If it is already exactly the correct symlink, do nothing
  if [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]]; then
    c_ok "Already correctly linked: $dst"
    return
  fi

  # If something exists (broken symlink, real folder, real file) -> backup
  if [[ -e "$dst" || -L "$dst" ]]; then
    mkdir -p "$BACKUP_DIR"
    mkdir -p "$(dirname "$BACKUP_DIR/${dst#$HOME/}")"
    mv "$dst" "$BACKUP_DIR/$(basename "$dst")_$(date +%s)" 2>/dev/null || mv "$dst" "$BACKUP_DIR/"
    c_warn "Backup created for: $dst"
  fi

  mkdir -p "$(dirname "$dst")"
  ln -s "$src" "$dst"
  c_ok "Symlink: $dst -> $src"
}

# ────────────────────────────────────────────────────────────
# 5. Configuration Symlinks
# ────────────────────────────────────────────────────────────
c_info "Creating configuration symlinks..."

mkdir -p "$CONFIG_DST"

link_item "$CONFIG_SRC/alacritty"     "$CONFIG_DST/alacritty"
link_item "$CONFIG_SRC/fastfetch"     "$CONFIG_DST/fastfetch"
link_item "$CONFIG_SRC/nvim"          "$CONFIG_DST/nvim"
link_item "$CONFIG_SRC/tmux"          "$CONFIG_DST/tmux"
link_item "$CONFIG_SRC/zsh"           "$CONFIG_DST/zsh"
link_item "$CONFIG_SRC/homebrew"      "$CONFIG_DST/homebrew"

# ────────────────────────────────────────────────────────────
# 5b. ~/.zshenv - required for zsh (and the Oh My Zsh installer)
#     to know where ZDOTDIR is BEFORE touching .zshrc
# ────────────────────────────────────────────────────────────
ZSHENV_PATH="$HOME/.zshenv"

# Definimos el bloque de variables XDG y ZDOTDIR
read -r -d '' XDG_BLOCK << 'EOF' || true

# --- XDG Base Directory Specification ---
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export ZDOTDIR="$HOME/.config/zsh"
EOF

if [[ -f "$ZSHENV_PATH" ]]; then
  # Comprobamos si ya tiene la variable para evitar duplicados si lo ejecutas varias veces
  if grep -qF 'XDG_CONFIG_HOME' "$ZSHENV_PATH"; then
    c_ok "$HOME/.zshenv already contains XDG variables."
  else
    # Hacemos backup usando tus variables
    mkdir -p "$BACKUP_DIR"
    cp "$ZSHENV_PATH" "$BACKUP_DIR/.zshenv_$(date +%s)"
    c_warn "Backup of existing ~/.zshenv created."
    
    # Añadimos las variables al final del archivo
    echo "$XDG_BLOCK" >> "$ZSHENV_PATH"
    c_ok "$HOME/.zshenv updated with XDG variables and ZDOTDIR."
  fi
else
  # Si no existe, lo creamos directamente
  echo "$XDG_BLOCK" > "$ZSHENV_PATH"
  c_ok "$HOME/.zshenv created with XDG variables and ZDOTDIR."
fi

# Export ZDOTDIR in THIS session of the script as well (the file above
# is only read when launching a new shell, not in this process)
export ZDOTDIR="$CONFIG_DST/zsh"

# ─────────────────────────────────────────────────────────────────
# 5c. Oh My Zsh - official installation + versioned custom/ overlay
# ─────────────────────────────────────────────────────────────────
OMZ_DST="$CONFIG_DST/oh-my-zsh"

if [[ ! -d "$OMZ_DST" ]]; then
  c_info "Installing Oh My Zsh (official)..."
  export ZSH="$OMZ_DST"
  export RUNZSH=no
  export CHSH=no
  export KEEP_ZSHRC=yes
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  c_ok "Oh My Zsh installed in $OMZ_DST"
else
  c_ok "Oh My Zsh is already installed in $OMZ_DST"
fi

# Replace the default custom/ with our versioned folder from the repo
if [[ -d "$OMZ_DST/custom" && ! -L "$OMZ_DST/custom" ]]; then
  mkdir -p "$BACKUP_DIR"
  mv "$OMZ_DST/custom" "$BACKUP_DIR/oh-my-zsh-custom_$(date +%s)"
  c_warn "Default Oh My Zsh custom/ folder moved to backup."
fi
link_item "$CONFIG_SRC/oh-my-zsh/custom" "$OMZ_DST/custom"

# ────────────────────────────────────────────────────────────
# 6. Fonts (Hack Nerd Font)
# ────────────────────────────────────────────────────────────
if [[ -d "$DOTFILES_DIR/fonts/Hack" ]]; then
  c_info "Installing Hack Nerd Font..."
  mkdir -p "$FONTS_DST"
  cp -n "$DOTFILES_DIR"/fonts/Hack/*.ttf "$FONTS_DST/" 2>/dev/null || true
  c_ok "Fonts copied to $FONTS_DST"
else
  c_warn "Fonts folder not found. Skipping."
fi

# ────────────────────────────────────────────────────────────
# 7. Third-party themes/frameworks not versioned (vendored)
# ────────────────────────────────────────────────────────────

# Powerlevel10k
P10K_DIR="$CONFIG_DST/oh-my-zsh/custom/themes/powerlevel10k"
if [[ ! -d "$P10K_DIR" ]]; then
  c_info "Powerlevel10k not found in custom/themes. Cloning..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
  c_ok "Powerlevel10k cloned."
else
  c_ok "Powerlevel10k already present."
fi

# zsh-autosuggestions
AUTOSUGGESTIONS_DIR="$CONFIG_DST/oh-my-zsh/custom/plugins/zsh-autosuggestions"
if [[ ! -d "$AUTOSUGGESTIONS_DIR" ]]; then
  c_info "Cloning zsh-autosuggestions..."
  git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git "$AUTOSUGGESTIONS_DIR"
  c_ok "zsh-autosuggestions cloned."
else
  c_ok "zsh-autosuggestions already present."
fi

# zsh-syntax-highlighting
SYNTAX_HL_DIR="$CONFIG_DST/oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
if [[ ! -d "$SYNTAX_HL_DIR" ]]; then
  c_info "Cloning zsh-syntax-highlighting..."
  git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git "$SYNTAX_HL_DIR"
  c_ok "zsh-syntax-highlighting cloned."
else
  c_ok "zsh-syntax-highlighting already present."
fi

# Zathura (external theme)
ZATHURA_THEME_REPO="https://github.com/pwmt/zathura.git"
ZATHURA_DST="$CONFIG_DST/zathura"
if [[ ! -d "$ZATHURA_DST" ]]; then
  c_info "Cloning zathura theme..."
  git clone --depth=1 "$ZATHURA_THEME_REPO" "$ZATHURA_DST"
  c_ok "Zathura theme cloned."
else
  c_ok "zathura already present in $ZATHURA_DST."
fi

# ────────────────────────────────────────────────────────────
# 8. LazyVim: headless sync of plugins using lazy-lock.json
# ────────────────────────────────────────────────────────────
if command -v nvim &>/dev/null; then
  c_info "Synchronizing LazyVim plugins (headless)..."
  nvim --headless "+Lazy! sync" +qa || c_warn "Lazy sync completed with warnings, check manually with :Lazy"
  c_ok "Neovim plugins synchronized."
else
  c_warn "nvim is not available in the PATH yet (did brew bundle install it? check the Brewfile). Run ':Lazy sync' manually the first time you open nvim."
fi

# ────────────────────────────────────────────────────────────
# 9. Default shell -> zsh
# ────────────────────────────────────────────────────────────
ZSH_PATH="$(command -v zsh)"
if [[ "$SHELL" != "$ZSH_PATH" ]]; then
  c_info "Changing default shell to zsh ($ZSH_PATH)..."
  if ! grep -qx "$ZSH_PATH" /etc/shells; then
    echo "$ZSH_PATH" | sudo tee -a /etc/shells >/dev/null
  fi
  chsh -s "$ZSH_PATH"
  c_ok "Default shell changed to zsh. Close and reopen the terminal for changes to take effect."
else
  c_ok "zsh is already the default shell."
fi

# ────────────────────────────────────────────────────────────
# Final Summary
# ────────────────────────────────────────────────────────────
echo ""
c_ok "Installation completed."
if [[ -d "$BACKUP_DIR" ]]; then
  c_info "A backup of your previous configs was created at: $BACKUP_DIR"
fi
c_info "Open Alacritty and select the 'Hack Nerd Font' font in alacritty.toml if it is not already configured."
c_info "ZDOTDIR points to $CONFIG_DST/zsh - open a NEW terminal (running 'source' is not enough) for ~/.zshenv to take effect."
c_info "Verify inside .config/zsh/.zshrc that ZSH=\"$CONFIG_DST/oh-my-zsh\""

