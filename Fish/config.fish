if status is-interactive
    # Commands to run in interactive sessions can go here
end

set -U fish_greeting ""

# Custom aliases
alias lh='ls -lAh --color=auto'
alias la='ls -A --color=auto'
alias grep='rg'
alias e='exit'
alias ls='ls --color=auto'
alias ':q'='exit'
alias mv='mv -i'
alias rm='rm -i'
alias gs='git status'
alias p='pkill'
alias v='vim'
alias yaf='yay; flatpak update'
alias stcli='speedtest-cli'
alias autorm='yay -R $(yay -Qdtq)'
alias autoremove='autorm'
alias diskhealth='k4dirstat'
alias search='pacman -Qsq'

# Config shortcuts
alias vimrc='vim ~/.vimrc'
alias bashrc='vim ~/.bashrc'
alias qtile='vim ~/.config/qtile/config.py'

# Exports
export EDITOR=vim
export TERM=xterm-256color
export HISTCONTROL=ignoreboth
export TERM='xterm-256color'
export LANG="en_US.UTF-8"
export LC_ALL="C"
export HISTSIZE=10000
export HISTFILESIZE=10000
