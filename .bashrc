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

if [ -f ~/.bashrc_addon ]; then
  . ~/.bashrc_addon
fi