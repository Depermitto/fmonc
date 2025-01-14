#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

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

# Config shortcuts
alias vimrc='vim ~/.vimrc'
alias bashrc='vim ~/.bashrc'
alias qtile='vim ~/.config/qtile/config.py'

# PS's
PS1='\e[0;32m[\u@\h \w]\$ \e[m'

# Exports
export EDITOR=vim
export TERM=xterm-256color
export HISTCONTROL=ignoreboth
export TERM='xterm-256color'
