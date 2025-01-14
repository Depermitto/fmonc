# Install powerlevel10k to ~/.local/share/ and zsh-suggestions via a package manager.

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=2000
SAVEHIST=2000
setopt autocd extendedglob nomatch notify
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/permito/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

unsetopt BEEP
source ~/.local/share/powerlevel10k/powerlevel10k.zsh-theme
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Custom aliases
alias ls='eza'
alias la='eza -al'
alias grep='rg'
alias e='exit'
alias ':q'='exit'
alias ':wq'='exit'
alias mv='mv -i'
alias rm='rm -i'
alias gs='git status'
alias purge_sync_conflicts="find ~ -name '*sync-conflict*' 2> /dev/null -exec rm -f {} \;"
alias logout='pkill -KILL -u $(whoami)'

# Exports
export EDITOR=nvim
export TERM=xterm-256color
export TERM='xterm-256color'
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# >>> juliaup initialize >>>

# !! Contents within this block are managed by juliaup !!

path=('/home/permito/.juliaup/bin' $path)
export PATH

# <<< juliaup initialize <<<
