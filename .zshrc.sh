# Ensure rustup's cargo/bin is at the front of PATH
export PATH="$HOME/.cargo/bin:$PATH"

export PS1="\[\e[0;31m\]\u@\h\[\e[m\]:\[\e[0;32m\]\w\[\e[m\] > "
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

# Install ripgrep (rg) if not already installed
if ! command -v rg >/dev/null 2>&1; then
  echo "[.bashrc] Installing ripgrep (rg)..."
  if command -v apt-get >/dev/null 2>&1; then
    apt-get update && apt-get install -y ripgrep
  else
    echo "[.bashrc] Could not find a supported package manager to install ripgrep. Please install it manually."
  fi
fi

# Install zsh if not already installed
if ! command -v zsh >/dev/null 2>&1; then
  echo "[.bashrc] Installing zsh..."
  if command -v apt-get >/dev/null 2>&1; then
    apt-get update && apt-get install -y zsh
  else
    echo "[.bashrc] Could not find a supported package manager to install zsh. Please install it manually."
  fi
fi

# Install fzf if not already installed
if ! command -v fzf >/dev/null 2>&1; then
  echo "[.bashrc] Installing fzf..."
  if command -v apt-get >/dev/null 2>&1; then
    apt-get update && apt-get install -y fzf
  else
    echo "[.bashrc] Could not find a supported package manager to install fzf. Please install it manually."
  fi
fi

# Install bat if not already installed
if ! command -v batcat >/dev/null 2>&1 && ! command -v bat >/dev/null 2>&1; then
  echo "[.bashrc] Installing bat..."
  if command -v apt-get >/dev/null 2>&1; then
    apt-get update && apt-get install -y bat
  else
    echo "[.bashrc] Could not find a supported package manager to install bat. Please install it manually."
  fi
fi

# Alias cat to bat (batcat on Debian/Ubuntu)
if command -v batcat >/dev/null 2>&1; then
  alias cat='batcat --paging=never'
elif command -v bat >/dev/null 2>&1; then
  alias cat='bat --paging=never'
fi

# Install cargo if not already installed
if ! command -v cargo >/dev/null 2>&1; then
  echo "[.bashrc] Installing cargo..."
  if command -v apt-get >/dev/null 2>&1; then
    apt-get update && apt-get install -y cargo
  else
    echo "[.bashrc] Could not find a supported package manager to install cargo. Please install it manually."
  fi
fi

# Ensure Rust (rustc >=1.87.0) is installed for eza
min_rust_version=1.87.0
rustc_version="$(command -v rustc >/dev/null 2>&1 && rustc --version 2>/dev/null | awk '{print $2}')"
version_ge() {
  # returns 0 if $1 >= $2
  [ "$1" = "$2" ] && return 0
  local IFS=.
  local i ver1=($1) ver2=($2)
  # fill empty fields in ver1 with zeros
  for ((i=${#ver1[@]}; i<${#ver2[@]}; i++)); do
    ver1[i]=0
  done
  for ((i=0; i<${#ver1[@]}; i++)); do
    if [[ -z ${ver2[i]} ]]; then
      # fill empty fields in ver2 with zeros
      ver2[i]=0
    fi
    if ((10#${ver1[i]} > 10#${ver2[i]})); then
      return 0
    fi
    if ((10#${ver1[i]} < 10#${ver2[i]})); then
      return 1
    fi
  done
  return 0
}
if ! command -v rustc >/dev/null 2>&1 || ! version_ge "$rustc_version" "$min_rust_version"; then
  echo "[.bashrc] Installing or updating Rust to >= $min_rust_version via rustup..."
  if command -v curl >/dev/null 2>&1; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    . "$HOME/.cargo/env"
    rustup update stable
    rustup default stable
    . "$HOME/.cargo/env"
  else
    echo "[.bashrc] curl is required to install Rust. Please install curl manually."
  fi
fi

# Install eza if not already installed
if ! command -v eza >/dev/null 2>&1; then
  echo "[.bashrc] Installing eza from source..."
  if command -v git >/dev/null 2>&1 && command -v cargo >/dev/null 2>&1; then
    tmp_eza_dir="$(mktemp -d)"
    git clone https://github.com/eza-community/eza.git "$tmp_eza_dir/eza" && \
    cd "$tmp_eza_dir/eza" && \
    sed -i 's/^channel = .*/channel = "stable"/' rust-toolchain.toml && \
    . "$HOME/.cargo/env" && \
    cargo install --path .
    cd ~
    rm -rf "$tmp_eza_dir"
  else
    echo "[.bashrc] git and cargo are required to build eza from source. Please install them manually."
  fi
fi

# Alias ls to eza with color and icons if available
if command -v eza >/dev/null 2>&1; then
  alias ls='eza --color=auto --icons'
fi
. "$HOME/.cargo/env"

# Set zsh as default shell if not already
if command -v zsh >/dev/null 2>&1 && [ "$SHELL" != "$(command -v zsh)" ]; then
  echo "[.bashrc] Setting zsh as default shell..."
  chsh -s "$(command -v zsh)" "$USER" || true
  # If running interactively and not already in zsh, exec zsh
  if [[ $- == *i* ]] && [ -z "$ZSH_VERSION" ]; then
    exec zsh
  fi
fi