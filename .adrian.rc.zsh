# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
    source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"

    # Syntax Highlighting over-rides
    ZSH_HIGHLIGHT_STYLES[globbing]='fg=yellow'
    # ZSH_HIGHLIGHT_STYLES[command]='fg=white,bold,bg=green'
    # ZSH_HIGHLIGHT_STYLES[builtin]='fg=white,bold,bg=green'
    # ZSH_HIGHLIGHT_STYLES[alias]='fg=white,bold,bg=green'
    ZSH_HIGHLIGHT_STYLES[path]='bold'
    ZSH_HIGHLIGHT_PATTERNS+=('rm -rf *' 'fg=white,bold,bg=red')
fi

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
