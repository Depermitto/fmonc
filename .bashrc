# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

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
alias psearch='ps -e | grep'
alias sleep='systemctl suspend'
alias shut='shutdown now'
alias purge_sync_conflicts="find . -iname '*sync-conflict*' -print0 2> /dev/null | xargs -0 rm"

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


export PATH=/home/permito/.cargo/bin:/usr/lib64/ccache:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin:/home/permito/.dotnet/tools:/var/lib/snapd/snap/bin:/home/permito/go/bin:/home/permito/.local/bin

# >>> juliaup initialize >>>

# !! Contents within this block are managed by juliaup !!

case ":$PATH:" in
    *:/home/permito/.juliaup/bin:*)
        ;;

    *)
        export PATH=/home/permito/.juliaup/bin${PATH:+:${PATH}}
        ;;
esac

# <<< juliaup initialize <<<
