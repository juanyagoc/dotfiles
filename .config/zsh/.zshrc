# =========================================
# Powerlevel10k instant prompt
# =========================================
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# =========================================
# Variables Globales (XDG y Zsh)
# =========================================
export ZSH="$HOME/.config/oh-my-zsh"
export HISTFILE="$ZDOTDIR/.zsh_history"
export ZSH_COMPDUMP="$ZDOTDIR/.zcompdump"
export CLICOLOR=1
export LSCOLORS="GxFxCxDxBxegedabagaced"
export EDITOR='nvim'
export GPG_TTY=$(tty)

# =========================================
# Gestión del PATH
# =========================================
typeset -U PATH           # No duplicados en el path

path_add() {
  case ":$PATH:" in
    *":$1:"*) ;;          # ya existe, no hace nada
    *) PATH="$1:$PATH" ;; # si no existe, añade
  esac
}

# Añadir rutas base
# Inicializar Homebrew correctamente para Apple Silicon
eval "$(/opt/homebrew/bin/brew shellenv)"
export HOMEBREW_NO_ENV_HINTS=1
path_add "/usr/local/bin"
path_add "$HOME/.local/bin"
path_add "$HOME/.local/share/elan/bin"

# ================================================
# Entornos (Python, Haskell, Lean, Terminal, Java, Claude, R)
# ================================================
# Pyenv
export PYENV_ROOT="$HOME/.local/share/pyenv"
path_add "$PYENV_ROOT/bin"
eval "$(pyenv init -)"

# GHCup & Cabal
export GHCUP_USE_XDG_DIRS=1
export CABAL_DIR="$HOME/.local/share/cabal"
[ -f "$HOME/.local/share/ghcup/env" ] && source "$HOME/.local/share/ghcup/env"

# Haskell
export STACK_ROOT="$HOME/.local/share/stack"

# Lean (elan)
export ELAN_HOME="$HOME/.local/share/elan"

# Terminal
export TERMINFO="$HOME/.local/share/terminfo"

# Java
export GRADLE_USER_HOME="$HOME/.local/share/gradle"

# Claude
export CLAUDE_CONFIG_HOME="$HOME/.local/share/claude"

# OBSIDIAN CLI
if [[ -d "/Applications/Obsidian.app/Contents/MacOS" ]]; then
    export PATH="$PATH:/Applications/Obsidian.app/Contents/MacOS"
fi

# R
export R_ENVIRON_USER="$HOME/.config/R/Renviron"
export R_HISTFILE="$HOME/.local/state/R/Rhistory"

# =========================================
# Oh My Zsh (Tema y Plugins)
# =========================================
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
)

# Cargar framework
source $ZSH/oh-my-zsh.sh

# Configuración extra de autocompletado para el menú
zstyle ':completion:*' menu select

# =========================================
# Alias y Funciones
# =========================================
alias gcc="gcc-15"
alias g++="g++-15"
alias pc="realpath sol.cpp | pbcopy"
alias v="nvim"

# Crear un nuevo archivo de solución de un problema de Codeforces
function cfnew {
    cp ~/templates/cf.cpp "$1".cpp
    nvim "$1".cpp
}

# =========================================
# Carga de Powerlevel10k
# =========================================
[[ ! -f "$ZDOTDIR/.p10k.zsh" ]] || source "$ZDOTDIR/.p10k.zsh"


[ -f "/Users/juanyago/.local/share/ghcup/env" ] && . "/Users/juanyago/.local/share/ghcup/env" # ghcup-env
