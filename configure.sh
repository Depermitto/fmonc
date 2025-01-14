#!/usr/bin/bash
# Configure config files for the install.sh script :)


bold=$(tput bold)
normal=$(tput sgr0)
green='\033[0;31m'
cyan='\033[0;36m'
nocolor='\033[0m'


success() {
    echo -e "${cyan}${bold}>>>  -------------------------"
    echo -e ">>>  Configuration successful!"
    echo -e ">>>  -------------------------${nocolor}"
    echo
    sleep 1
}


starting() {
    for i in {3..1}
    do
        echo -e "${green}>>>${nocolor}  Starting in ${green}$i${nocolor} seconds..."
        sleep 0.75
    done
}


next() {
    echo -e "${green}>>>${nocolor}        Next entry...     "
    echo
    sleep 0.5
}


finish() {
    success &&
    next &&
    starting
}


configureAlacritty() {
mkdir ~/.config/alacritty 2> /dev/null
ln -fv ~/Gitlab/.config/alacritty/alacritty.yml ~/.config/alacritty/
}


configureBash() {
ln -fv ~/Gitlab/.bashrc ~/.bashrc 
}


configureFish() {
ln -fv ~/Gitlab/.config/fish/config.fish ~/.config/fish/
}


configureVim() {
if ! /usr/bin/ls -A1q ~/.vim | grep -q . ; then
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    ln -fv ~/Gitlab/.vimrc ~/.vimrc &&

    vim +PlugInstall &&
    cd ~/.vim/plugged/youcompleteme/ &&
    yes | yay -S cmake &&
    python3 install.py 
fi

ln -fv ~/Gitlab/.vim/plugged/youcompleteme/plugin/youcompleteme.vim ~/.vim/plugged/youcompleteme/plugin/ 
}


configureNeovim() {
if ! /usr/bin/ls -A1q ~/.config/nvim | grep -q . ; then
    sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
           https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

    mkdir ~/.config/nvim/ 

    nvim +PlugInstall &&
    sudo npm i -g pyright &&
    sudo npm i -g bash-language-server &&
    sudo npm i -g vim-language-server
fi

ln -fv ~/Gitlab/.config/nvim/init.vim ~/.config/nvim/
}


configureDoom() {
if ! /usr/bin/ls -A1q ~/.doom.d | grep -q . ; then
    git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.emacs.d &&
    ~/.emacs.d/bin/doom install &&
    ~/.emacs.d/bin/doom sync
fi

ln -fv ~/Gitlab/.doom.d/* ~/.doom.d/ &&
~/.emacs.d/bin/doom sync
}


## CONFIGURATION ##

if [ -z $1 ]; then
    echo -e "Type 'help' to show help"
else
    case $1 in
        'help')
            printf "'alacritty': Configure alacritty,\n'bash': Configure Bash,\n'fish': Configure fish,\n'vim': Configure vim,\n'nvim': Configure neovim,\n'doom': Configure doomemacs,\n'all': Configure all packs.\n\nPlease put arguments individually.\n"
            ;;
        alacritty)
            configureAlacritty
            success
            ;;
        bash)
            configureBash
            success
            ;;
        fish)
            configureFish
            success
            ;;
        vim)
            configureVim
            success
            ;;
        nvim)
            configureNeovim
            success
            ;;
        doom)
            configureDoom
            success
            ;;
        all)
            configureAlacritty && finish &&
            configureBash && finish &&
            configureVim && finish &&
            configureNeovim && finish &&
            configureDoom && success
            ;;
        *)
            echo -e "Script works! However, your output is '$1',\nwhich is not considered a correct argument.\n\nType 'help' to show help."
            ;;
    esac
fi
