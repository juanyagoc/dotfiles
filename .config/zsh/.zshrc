# =========================================
# Powerlevel10k instant prompt
# =========================================
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$XDG_CONFIG_HOME/oh-my-zsh"
export HISTFILE="$XDG_STATE_HOME/zsh/history"
export ZSH_COMPDUMP="$XDG_CACHE_HOME/zsh/.zcompdump"
export CLICOLOR=1
export LSCOLORS="GxFxCxDxBxegedabagaced"
export EDITOR='nvim'
export GPG_TTY=$(tty)
gpg-connect-agent updatestartuptty /bye >/dev/null 2>&1


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
# Inicializar Homebrew correctamente
eval "$(/opt/homebrew/bin/brew shellenv)"
export HOMEBREW_NO_ENV_HINTS=1
export HOMEBREW_NO_ANALYTICS=1
path_add "/usr/local/bin"
path_add "$HOME/.local/bin"

# =========
# Entornos
# =========
# Python & Pyenv
export PYENV_ROOT="$XDG_DATA_HOME/pyenv"
path_add "$PYENV_ROOT/bin"
eval "$(pyenv init -)"
# No sé si es con guion o sin guion
export PYTHON_HISTORY="$XDG_STATE_HOME/python/history"
export PYTHONHISTORY="$XDG_STATE_HOME/python/history"
export IPYTHONDIR="$XDG_CONFIG_HOME/ipython"

# GHCup & Cabal
export GHCUP_USE_XDG_DIRS=1
export CABAL_DIR="$XDG_DATA_HOME/cabal"
[ -f "$XDG_DATA_HOME/ghcup/env" ] && source "$XDG_DATA_HOME/ghcup/env"

# Haskell
export STACK_ROOT="$XDG_DATA_HOME/stack"

# Lean (elan)
export ELAN_HOME="$XDG_DATA_HOME/elan"
path_add "$ELAN_HOME/bin"

# Terminal
export TERMINFO="$XDG_DATA_HOME/terminfo"
export TERMINFO_DIRS="$XDG_DATA_HOME/terminfo:/usr/share/terminfo"

# Java
export GRADLE_USER_HOME="$XDG_DATA_HOME/gradle"

# Claude
export CLAUDE_CONFIG_DIR="$XDG_DATA_HOME/claude"

# NuGet (.net)
export NUGET_PACKAGES="$XDG_DATA_HOME/NuGet"
export NUGET_HTTP_CACHE_PATH="$XDG_CACHE_HOME/NuGet/http-cache"

# Maven
#export MAVEN_OPTS="-Dmaven.repo.local=$XDG_DATA_HOME/maven/repository $MAVEN_OPTS"
alias mvn="mvn -gs $XDG_CONFIG_HOME/maven/settings.xml"

# Codex CLI
export CODEX_HOME="$XDG_DATA_HOME/codex"

# OBSIDIAN CLI
if [[ -d "/Applications/Obsidian.app/Contents/MacOS" ]]; then
    export PATH="$PATH:/Applications/Obsidian.app/Contents/MacOS"
fi

# R
export R_ENVIRON_USER="$XDG_CONFIG_HOME/R/Renviron"
export R_HISTFILE="$XDG_STATE_HOME/R/Rhistory"

# Matplotlib
export MPLCONFIGDIR="$XDG_CONFIG_HOME/matplotlib"

# Node
export NODE_REPL_HISTORY="$XDG_STATE_HOME/node/history"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export NPM_CONFIG_CACHE="$XDG_CACHE_HOME/npm"

# Vim
export VIMINFO="$XDG_STATE_HOME/vim/viminfo"

# Wget
export WGETRC="$XDG_CONFIG_HOME/wget/wgetrc"

# Varios
export PSQL_HISTORY="$XDG_STATE_HOME/psql/history"

export DOTNET_CLI_HOME="$XDG_DATA_HOME/dotnet"

export LESSHISTFILE="$XDG_STATE_HOME/less/history"

# =========================================
# Oh My Zsh (Tema y Plugins)
# =========================================
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    z
    vi-mode
    direnv
    extract
)

# Cargar framework
source $ZSH/oh-my-zsh.sh

# Plugin z de oh-my-zsh
export _Z_DATA="$HOME/.local/share/z_data"

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

# Si estamos en una terminal interactiva y NO estamos ya dentro de tmux
if [[ -z "$TMUX" ]] && [[ -n "$PS1" ]]; then
    exec tmux new-session -A -s main
fi

