# load keys

# SSH
function loadssh() {
  ssh-add -l || ssh-add ~/.ssh/id_rsa ~/.ssh/id_gitlab # ~/.ssh/prometheus_id_rsa
}

# Java/JENV
export JENV_SHELL=zsh
export JENV_LOADED=1
unset JAVA_HOME
source '/usr/local/Cellar/jenv/0.5.2/libexec/libexec/../completions/jenv.zsh'
jenv rehash 2>/dev/null
jenv() {
  typeset command
  command="$1"
  if [ "$#" -gt 0 ]; then
    shift
  fi

  case "$command" in
  enable-plugin|rehash|shell|shell-options)
    eval `jenv "sh-$command" "$@"`;;
  *)
    command jenv "$command" "$@";;
  esac
}

# k8s
source <(kubectl completion zsh)

# Zsh temp folder
TMPPREFIX="${TMPDIR%/}/zsh"
if [[ ! -d "$TMPPREFIX" ]]; then
  mkdir -p "$TMPPREFIX"
fi

# Iterm2
if [[ -s "$HOME/.iterm2_shell_integration.zsh" ]]; then
  source "$HOME/.iterm2_shell_integration.zsh"
fi

bindkey "^X\\x7f" backward-kill-line
bindkey "^X^_" redo
bindkey -e
bindkey '^[[1;9A' beginning-of-line
bindkey '^[[1;9B' end-of-line
bindkey '^[[1;9C' forward-word
bindkey '^[[1;9D' backward-word

# Python
source /usr/local/bin/virtualenvwrapper.sh

# Lazy load zsh
export NVM_DIR="$HOME/.nvm"
export NVM_PREFIX="$(brew --prefix nvm)"
[ -s "$NVM_PREFIX/etc/bash_completion" ] && . "$NVM_PREFIX/etc/bash_completion"
export PATH="$NVM_DIR/versions/node/v$(<$NVM_DIR/alias/default)/bin:$PATH"
alias nvm="unalias nvm; [ -s "$NVM_PREFIX/nvm.sh" ] && . "$NVM_PREFIX/nvm.sh"; nvm $@"

# Starship prompt
eval "$(starship init zsh)"
