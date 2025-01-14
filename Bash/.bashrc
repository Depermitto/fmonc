#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias grep='rg'
alias e='exit'
alias ls='ls --color=auto'
alias ':q'='exit'
PS1='\e[0;32m[\u@\h] \W \$ \e[m'
