#!/usr/bin/env bash
# Simple bash script to install all nessesary files for pmjial :)


bold=$(tput bold)
normal=$(tput sgr0)
green='\033[0;33m'
cyan='\033[0;36m'
nocolor='\033[0m'

success() {
    echo -e "${cyan}${bold}>>>  ------------------------"
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

gityay() {
    printf "${bold}${cyan}>>>>>${nocolor}${bold} ************************ STARTING ON AUR HELPER AND GIT ************************ ${cyan}<<<<<${nocolor}"
    sleep 2

    # Installing git
    yes | pacman -S git &&
    finish

    # Install yay
    yes | sudo pacman -S --needed git base-devel &&
    git clone https://aur.archlinux.org/yay.git &&
    cd yay &&
    yes | makepkg -si &&
    success
}


## ENABLING FLATPAK ##

flathub() {
    printf "${bold}${cyan}>>>>>${nocolor}${bold} ************************ ENABLING FLATHUB REPOSITORY ************************ ${cyan}<<<<<${nocolor}"
    sleep 2

    # Installing flatpak
    yes | yay -S flatpak
    finish

    # Actually enabling it
    flatpak --user remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    success
}


## DRIVERS AND SUPPORT ##

drivers() {
    printf "${bold}${cyan}>>>>>${nocolor}${bold} ************************ MOVING ON TO DRIVERS AND SUPPORT ************************ ${cyan}<<<<<${nocolor}"
    sleep 2

    DRIVERS=("ntfs-3g" "packagekit-qt5" "noto-fonts-emoji" "ripgrep" "fd" "pulseaudio-bluetooth")
    # Installing ntfs drivers, packagekit for kde-discover, emojis and prerequisites for doom emacs

    for driver in ${DRIVERS[@]}; do
        yes | yay -S $driver &&
        if [[ "$driver" != "${DRIVERS[-1]}" ]]; then
            finish
        else
            success
        fi
    done

}

## APPS ##

apps() {
    printf "${bold}${cyan}>>>>>${nocolor}${bold} ************************ MOVING ON TO APPLICATIONS ************************ ${cyan}<<<<<${nocolor}"
    sleep 2


    APPS=("kotatogram-desktop-beta-dynamic-bin" "alacritty" "bitwarden" "emacs" "ungoogled-chromium-bin" "qbittorrent" "kdeconnect" "fish" "notepadqq" "nvim" "nerd-fonts-complete" "pyenv-virtualenv")

    for app in ${APPS[@]}; do
        yes | yay -S $app &&
        finish
    done


    APPS_NOCONFIRM=("kdiff3" "man" "bat" "heroic-games-launcher-bin" "vim" "stacer-bin" "geeqie" "alacritty-xwayland")

    for appc in ${APPS_NOCONFIRM[@]}; do
        yay -S --noconfirm $appc &&
        finish
    done


    ## Enabling steam
    sudo cp ~/Backup/pacman.conf /etc/
    sudo pacman -Sy
    sudo pacman -Sy steam
    finish


    APPS_FLATPAK=("com.interversehq.qView")

    for appf in ${APPS_FLATPAK[@]}; do
        flatpak -y install flathub $appf &&
        if [[ "$appf" != "${APPS_FLATPAK[-1]}" ]]; then
            finish
        else
            success
        fi
    done

}


## INSTALLING ##

if [ -z $1 ]; then
    echo -e "Type 'help' to show help"
else
    case $1 in
        'help')
            printf "'Apps': install applications only,\n'Drivers': install drivers only,\n'AUR': install git and yay only,\n'Flatpak': enable flathub only,\n'All': install all packs.\n\nPlease put arguments individually.\n"
            ;;
        Flatpak)
            flathub
            ;;
        Apps)
            apps
            ;;
        Drivers)
            drivers
            ;;
        AUR)
            gityay
            ;;
        All)
            gityay &&
            flathub &&
            drivers &&
            apps
            ;;
        *)
            echo -e "Script works! However, your output is '$1',\nwhich is not considered a correct argument.\n\nType 'help' to show help."
            ;;
    esac
fi

yay -R $(yay -Qdtq) &&
success
