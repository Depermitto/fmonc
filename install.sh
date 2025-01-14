#!/usr/bin/bash
# Simple bash script to install all nessesary files for pmjial :)


bold=$(tput bold)
normal=$(tput sgr0)
green='\033[0;33m'
cyan='\033[0;36m'
nocolor='\033[0m'


success() {
    echo -e "\n${cyan}${bold}>>>  ------------------------"
    echo -e ">>>  Installation successful!"
    echo -e ">>>  ------------------------${nocolor}"
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
    echo sleep 0.5
}


finish() {
    success &&
    next &&
    starting
}



## GIT AND YAY ##

installGitYay() {
    printf "${bold}${cyan}>>>>>${nocolor}${bold} ************************ STARTING ON AUR HELPER AND GIT ************************ ${cyan}<<<<<${nocolor}\n"
    sleep 2

    # Installing git
    yes | pacman -S git &&
    finish

    # Install yay
    yes | sudo pacman -S --needed git base-devel &&
    git clone https://aur.archlinux.org/yay.git &&
    cd yay &&
    yes | makepkg -si
}



## ENABLING FLATHUB ##

enableFlathub() {
    printf "${bold}${cyan}>>>>>${nocolor}${bold} ************************ ENABLING FLATHUB REPOSITORY ************************ ${cyan}<<<<<${nocolor}\n"
    sleep 2

    # Installing flatpak
    yes | pacman -S flatpak &&
    finish

    # Enabling flathub
    flatpak --user remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    success
}



## DRIVERS AND SUPPORT ##

installDrivers() {
    # Installing ntfs drivers, packagekit for kde-discover, emojis and prerequisites for doom emacs
    printf "${bold}${cyan}>>>>>${nocolor}${bold} ************************ MOVING ON TO DRIVERS AND SUPPORT ************************ ${cyan}<<<<<${nocolor}\n"
    sleep 2

    yay -S ntfs-3g packagekit-qt5 noto-fonts-emoji nerd-fonts-complete fd
}



## APPS ##

installApps() {
    printf "${bold}${cyan}>>>>>${nocolor}${bold} ************************ MOVING ON TO APPLICATIONS ************************ ${cyan}<<<<<${nocolor}\n"
    sleep 2

    yay -S --needed kotatogram-desktop-beta-dynamic-bin alacritty bitwarden emacs qbittorrent fish pyenv-virtualenv pipewire-audio pipewire-docs pipewire-jack pipewire-pulse wireplumber plasma-pa ranger pamixer rofi xclip exa starship ripgrep kdiff3 man bat heroic-games-launcher-bin vim neovim stacer-bin alacritty-xwayland
}


installSteam() {
    # Enable steam mirrors
    sudo cp ~/Gitlab/etc/pacman.conf /etc/

    # Install steam
    sudo pacman -Sy steam
}


installAppsFlatpak() {
    flatpak -y install flathub com.interversehq.qView
}


## INSTALLING ##

if [ -z $1 ]; then
    echo -e "Type 'help' to show help"
else
    case $1 in
        'help')
            printf "'apps': Install basic applications only,\n'apps-flatpak': Install flatpaks only,\n'steam': Install steam only,\n'drivers': Install drivers only,\n'aur': Install git and yay only,\n'flatpak': Enable flathub only,\n'all': Install all packs.\n\nPlease put arguments individually.\n"
            ;;
        flatpak)
            enableFlathub &&
            success
            ;;
        apps)
            installApps &&
            success
            ;;
        apps-flatpak)
            installAppsFlatpak &&
            success
            ;;
        drivers)
            installDrivers &&
            success
            ;;
        steam)
            installSteam &&
            success
            ;;
        aur)
            installGitYay &&
            success
            ;;
        all)
            installGitYay && finish &&
            installApps && finish &&
            enableFlathub && finish &&
            installAppsFlatpak && finish &&
            installAppsNoConfirm && finish &&
            installDrivers && finish &&
            installSteam && success
            ;;
        *)
            echo -e "Script works! However, your output is '$1',\nwhich is not considered a correct argument.\n\nType 'help' to show help."
            ;;
    esac
fi
