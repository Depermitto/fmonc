#!/usr/bin/env bash
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


# Alacritty
if [ ! -d ~/.config/alacritty ]; then
    mkdir ~/.config/alacritty
fi

ln ~/Gitlab/Alacritty/alacritty.yml ~/.config/alacritty/ &&
finish

# Bash
ln ~/Gitlab/Bash/.bashrc ~/.bashrc &&
finish

# Vim
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

ln ~/Gitlab/Vim/.vimrc ~/.vimrc &&

vim +PlugInstall &&
cd ~/.vim/plugged/youcompleteme/ &&
yes | yay -S cmake &&
python3 install.py &&

yes | rm ~/.vim/plugged/youcompleteme/plugin/youcompleteme.vim &&
ln ~/Gitlab/Vim/youcompleteme.vim ~/.vim/plugged/youcompleteme/plugin/ &&
finish

# NeoVim
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

mkdir ~/.config/nvim/ &&
ln ~/Gitlab/Nvim/init.vim ~/.config/nvim/ &&

nvim +PlugInstall &&
finish

# Doom Emacs
git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.emacs.d
~/.emacs.d/bin/doom install
~/.emacs.d/bin/doom
ln ~/Gitlab/Doom/* ~/.doom.d/
success

# Qtile
ln ~/Gitlab/qtile/* ~/.config/qtile &&
mkdir ~/.config/qtile &&
success
