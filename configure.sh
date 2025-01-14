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

cp ~/Backup/Alacritty/alacritty.yml ~/.config/alacritty/ &&
finish

# Bash
cp ~/Backup/Bash/.bashrc ~/.bashrc &&
finish

# Vim
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

cp ~/Backup/Vim/.vimrc ~/.vimrc &&

vim +PlugInstall &&
cd ~/.vim/plugged/youcompleteme/ &&
yes | yay -S cmake &&
python3 install.py &&
finish

# Doom Emacs
git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.emacs.d
~/.emacs.d/bin/doom install
~/.emacs.d/bin/doom sync
cp ~/Backup/Doom/* ~/.doom.d/
success

# Qtile
cp ~/Backup/qtile/* ~/.config/qtile &&
mkdir ~/.config/qtile &&
success

# Git pushing and pulling
cp ~/Backup/id_ed25519* ~/.ssh/ &&
success
