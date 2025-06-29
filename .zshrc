# --- Zsh Environment ---

export EDITOR='nvim'
export GIT_EDITOR='nvim'

export PATH="/usr/local/go/bin:/usr/local/venv/bin:$PATH"
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LC_CTYPE=UTF-8

eval "$(dircolors -b)"
export LS_OPTIONS='--color=auto'
alias ls='ls $LS_OPTIONS'
alias ll='ls $LS_OPTIONS -l'
alias grep='grep --color=always --line-buffered'
alias fgrep='fgrep --color=always --line-buffered'

export CMAKE_GENERATOR=Ninja
export CMAKE_BUILD_TYPE=Debug
export CMAKE_COLOR_DIAGNOSTICS=ON
export CLICOLOR_FORCE=1
export LDFLAGS='-Wl,--color-diagnostics'

alias d3-cmake-debug='mkdir -p ~/d3-server/build_debug && cd ~/d3-server/build_debug && cmake -DCMAKE_BUILD_TYPE=Debug ..'
alias d3-cmake-release='mkdir -p ~/d3-server/build_release && cd ~/d3-server/build_release && cmake -DCMAKE_BUILD_TYPE=Release ..'
alias d3-build='ninja'
alias d3-build-regardless-of-errors='ninja -k 99999'
alias d3-build-non-parallel='ninja -j 1'
alias d3_isql='isql -v -k "DRIVER={MariaDB Unicode};SERVER=mysql;UID=root;PWD=Dvelop1!"'
alias d3_mysql='mysql -hmysql -uroot -pDvelop1!'
alias d3_jq='jq -r '"'"'. | "\(.time) \(.sev) \(.res.svc.name) \(.body)"'"'"
alias d3_log='tail -f /tmp/dlogserver.log | eval "${BASH_ALIASES[d3_jq]}"'

function d3-reset-conan
{
  rm -rf ~/.conan/
  rm -rf ~/.conan2/
  docker-entrypoint.sh
  echo "Conan reset done."
  echo "You will need your jFrog credentials to download the dependencies the next time you call d3-build-debug / d3-build-release"
  echo "Visit https://repo.d-velop.de/ui/user_profile to get them."
}

# --- Zinit Setup and Plugin Management ---

# Enable Powerlevel10k instant prompt. Must be sourced close to the top.
#if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
#fi

# --- Completions (must be before plugins and themes) ---
autoload -Uz compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'             # Case-insensitive
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"            # Use LS_COLORS
zstyle ':completion:*' menu no                                     # No default menu
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath' # fzf-tab preview
zstyle ':completion:*' dumpfile ~/.cache/zsh/.zcompdump            # Cache file
compinit # Initialize completions

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

if [ ! -d "$ZINIT_HOME" ]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

# Load Zinit Plugins
#zinit ice depth=1; zinit light romkatv/powerlevel10k # Powerlevel10k theme
zinit light zsh-users/zsh-syntax-highlighting  # Syntax highlighting
zinit light zsh-users/zsh-completions          # Enhanced completions
zinit light zsh-users/zsh-autosuggestions      # Autosuggestions from history
zinit light Aloxaf/fzf-tab                     # fzf integration for completions
zinit cdreplay -q # Replay Zinit commands

# --- Prompt Configuration ---
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# Must be sourced AFTER the powerlevel10k plugin is loaded.
#[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# Check if starship is installed
if ! command -v starship &> /dev/null; then
  # Install starship
  echo "Starship not found. Installing..."
  curl -sS https://starship.rs/install.sh | sh
  . ~/.zshrc
  echo "Starship installation complete."
fi

# --- History Settings ---
HISTSIZE=10000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# --- Keybindings ---
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region

# --- Aliases ---
# User's custom aliases
alias grep='grep --color=auto'

# eza/exa aliases
alias ls='eza --group-directories-first --icons'
alias la='eza -a --group-directories-first --icons'
alias l='eza -l --group-directories-first --icons'
alias ll='eza -la --group-directories-first --icons'

# bat/batcat aliases
alias bat='batcat'
alias fbat="fzf --preview 'batcat --style=numbers --color=always --line-range :500 {}'"

# git aliases
alias gs="git status --short"
alias gd="git diff --output-indicator-new=' ' --output-indicator-old=' '"
alias ga="git add"
alias gap="git add --patch"
alias gc="git commit"
alias gp="git push"
alias gu="git pull"
alias gl="git log --all --graph --pretty=format:'%C(magenta)%h %C(white) %an %ar%C(auto) %D%n%s%n'"
alias gb="git branch"
alias gba="git branch -a"
alias gn="git checkout -b"
alias gi="git init"
alias gcl="git clone"

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#3b3b3b"


# Use bat for cat
alias bat='batcat --paging=never'
alias cat='bat --paging=never --color=always --plain'

# --- Tool Specific Configurations ---
# FNM
FNM_PATH="$HOME/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$HOME/.local/share/fnm:$PATH"
  eval "$(fnm env)"
  eval "$(fnm env --use-on-cd)"
fi

# Keychain
if command -v keychain >/dev/null 2>&1; then
  eval $(keychain --eval --agents ssh id_ed25519 2>/dev/null)
fi

# Bun
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.Bun/_bun" # Bun completions
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# PNPM
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# Go
export PATH="$PATH:/usr/local/go/bin"
export GOPATH="$HOME/.local/go"
export PATH="$GOPATH/bin:$PATH"

# Zoxide
export _ZO_ECHO='1' # Echo directory on cd
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init --cmd cd zsh)"
fi

# Bat-man (Integrate bat with man pages)
export MANPAGER="sh -c 'col -bx | batcat -l man -p'"

# FZF
export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
--multi \
--preview-window=right:70%"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh # Source keybindings and completions

# Source cargo environment if exists
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# Enable colors for less
export LESS='-R'

# if grc is not installed install init
if ! command -v grc >/dev/null 2>&1; then
    apt install grc
fi

if command -v grc >/dev/null 2>&1; then
        alias natstat="grc natstat"
        alias ss="grc ss"
        alias tail="grc tail"
        
        if command -v docker >/dev/null 2>&1; then
                alias docker="grc docker"
        fi
        alias go="grc go"
fi

eval "$(starship init zsh)"
