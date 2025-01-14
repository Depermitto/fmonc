if status is-interactive
    # Commands to run in interactive sessions can go here
end

set -U fish_greeting ""

# Functions

which apt 2> /dev/null | grep -q .
set is_apt $status

which nala 2> /dev/null | grep -q .
set is_nala $status

which pacman 2> /dev/null | grep -q .
set is_pacman $status

which dnf 2> /dev/null | grep -q .
set is_dnf $status

function run
    argparse --name=run 'h/help' -- $argv
    or return

    
    if test $(count $argv) -eq 0; or set -q _flag_help
        echo "usage: run [-h|--help] TIMES COMMAND"
        return 0
    end


    for i in (seq 1 (math $argv[1]))
        $argv[2..]
    end
end

function isearch
    if test $is_apt -eq 0
        sudo apt list --installed | grep $argv
    else if test $is_dnf -eq 0
        sudo dnf list | grep $argv
    else if test $is_pacman -eq 0
        yay -Qsq $argv
    end
end

function autoremove
    if test $is_apt -eq 0
        if test $is_nala -eq 0
            sudo nala autoremove
        else
            sudo apt autoremove
        end
    else if test $is_dnf -eq 0
        sudo dnf autoremove
    else if test $is_pacman -eq 0
        yay -R (yay -Qdtq)
    end
end

function update
    if test $is_apt -eq 0
        if test $is_nala -eq 0
            sudo nala upgrade; flatpak update; sudo snap refresh
        else
            sudo apt update && sudo apt upgrade; flatpak update; sudo snap refresh
        end
    else if test $is_dnf -eq 0
        sudo dnf update; flatpak update
    else if test $is_pacman -eq 0
        yay; flatpak update
    end
end

# Custom aliases
alias ls='exa'
alias la='exa -al'
alias grep='rg'
alias e='exit'
alias ':q'='exit'
alias ':wq'='exit'
alias mv='mv -i'
alias rm='rm -i'
alias gs='git status'
alias p='pkill'
alias v='vim'
alias n='nvim'
alias diskhealth='k4dirstat'
alias pss='ps -e | grep'
alias zzz='systemctl suspend'
alias 6zz='shutdown now'

# Config shortcuts
alias vimrc='nvim ~/.vimrc'
alias nvimrc='nvim ~/.config/nvim/init.vim'
alias bashrc='nvim ~/.bashrc'
alias fishrc='nvim ~/.config/fish/config.fish'
alias logout='pkill -KILL -u $(whoami)'
alias sourcefish='source ~/.config/fish/config.fish'

# Exports
export EDITOR=nvim
export TERM=xterm-256color
export HISTCONTROL=ignoreboth
export TERM='xterm-256color'
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export HISTSIZE=10000
export HISTFILESIZE=10000

# Starship
starship init fish | source
