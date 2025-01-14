#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Functions

function run {
    num=$1
    shift
    for i in $(seq $num)
    do
        $@
    done
}

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
alias vim='nvim'

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
export LANG="en_US.UTF-8" 
export LC_ALL="C"
export HISTSIZE=10000
export HISTFILESIZE=10000
export XDG_CURRENT_DESKTOP=KDE

# Starship
eval "$(starship init bash)"
#neofetch
