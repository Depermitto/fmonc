if status is-interactive
    # Commands to run in interactive sessions can go here
end

set -U fish_greeting ""

# Functions


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


# Custom aliases
alias ls='exa'
alias la='exa -al'
#alias ls='ls --color=auto'
#alias lh='ls -lAh --color=auto'
#alias la='ls -A --color=auto'
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
alias yaf='yay; flatpak update; sudo snap refresh'
alias stcli='speedtest-cli'
alias autorm='yay -R $(yay -Qdtq)'
alias autoremove='autorm'
alias diskhealth='k4dirstat'
alias search='pacman -Qsq'
alias pss='ps -e | grep'
alias zzz='systemctl suspend'
alias 6zz='shutdown now'

# Config shortcuts
alias vimrc='nvim ~/.vimrc'
alias nvimrc='nvim ~/.config/nvim/init.vim'
alias swayrc='nvim ~/.config/sway/config'
alias bashrc='nvim ~/.bashrc'
alias fishrc='nvim ~/.config/fish/config.fish'
alias qtile='nvim ~/.config/qtile/config.py'
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
