#!/usr/bin/env bash
# configure.sh GENERATION 3

CONFIGURE_COMMAND="cp -vrf"

function packageManagerFind () {
  # Assigning error codes to variables
  which apt 2> /dev/null | grep -q .
  isApt="$?"

  which pacman 2> /dev/null | grep -q .
  isPacman="$?"

  which dnf 2> /dev/null | grep -q .
  isDnf="$?"

  # Finding the package manager
  if [ "$isApt" -eq 0 ]; then
    PACKAGE_MANAGER="apt install"
  elif [ "$isPacman" -eq 0 ]; then
    PACKAGE_MANAGER="pacman --needed -S"
  elif [ "$isDnf" -eq 0 ]; then
    PACKAGE_MANAGER="dnf install"
  else
    echo "Couldn't resolve distro. Exiting..."
    exit 1
  fi
}

function helpPage () {
  echo -e "Usage: conf.sh [OPTION] [TARGET(S)]

  -h                show this page
  -i [PACK(S)]      install pack(s), comma separated
  -c [APP(S)]       configure application(s), comma separated
  -l                print the list of available packs
  -e                print an example usage of this program
  -t [SOMETHING]    print SOMETHING

Make sure to update mirrors before proceeding."
}

function list () {
  echo -e "Available packs:

  Install packs:

    [ONLY ON ARCH-BASED]
    arch-essentials - stuff like ntfs-3g
    arch-steam      - setups steam
    arch-based      - installs yay AUR helper and Arch Tweak Tool
    arch-fonts      - nerd-fonts-complete (requires yay)

    [CROSS-DISTRO]
    flathub         - installs flatpak and setups flathub
    better          - ripgrep, starship, bat, exa, etc.

  Configuration packs:

    [ONLY ON UBUNTU-BASED]
    ubuntu-based    - installs nala and alacritty

    [ONLY ON FEDORA]
    fedora          - improves dnf (5 parallel downloads and fastest mirror)

    [CROSS-DISTRO]
    lsp             - lsp for bash, python and rust
    vim             - installs Packer and copies this repo's config file
    neovim          - similar to 'vim'
    bash            - this repo's bashrc and set ups starship prompt
    fish            - similar for bash
    doom            - configures doom-emacs"
}

function example () {
  echo -e "\nconf.sh -i flathub -c lsp,vim,neovim"
}


## INSTALL FUNCTIONS ##

function installSteam () {
  # Enable steam mirrors
  sudo cp -f ~/Gitlab/etc/pacman.conf /etc/

  # Install steam
  sudo pacman --needed -Sy steam
}

function installBased () {
  # Installing git
  sudo pacman --needed -S git &&

  # Installing yay
  sudo pacman --needed -S git base-devel &&
  git clone https://aur.archlinux.org/yay.git &&
  cd yay &&
  makepkg -si &&

  # Installing Arch Tweak Tool using yay
  yay --needed -S archlinux-tweak-tool
}

function installFlathub () {
  # Installing flatpak
  sudo $PACKAGE_MANAGER flatpak

  # Enabling flathub
  flatpak --user remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
}

function installBetter () {
  # Declaring the apps
  apps="exa ripgrep fish bat vim neovim kdiff3 xclip qbittorrent"

  # Installing the apps
  sudo $PACKAGE_MANAGER $apps

  # Installing starship
  curl -sS https://starship.rs/install.sh | sh
}

function install () {
  # Setting the $PACKAGE_MANAGER variable
  packageManagerFind &&

  # Finding and resolving packs
  for pack in $1; do
    case "${pack}" in
    "arch-essentials")
      sudo pacman --needed -S ntfs-3g packagekit-qt5 noto-fonts-emoji fd ;;
    "arch-steam")
      installSteam ;;
    "arch-based")
      installBased ;;
    "arch-fonts")
      sudo pacman --needed -S nerd-fonts-complete ;;
    "flathub")
      installFlathub ;;
    "better")
      installBetter ;;
    *)
      echo "One or more packs is incorrect." &&
      exit 1 ;;
    esac
  done
}


## CONFIGURE FUNCTIONS

function configureFedora () {
  # Checking if indeed on Fedora
  if [ "$isDnf" -eq 0 ]; then
    sudo $CONFIGURE_COMMAND "./etc/dnf/dnf.conf" "/etc/dnf/"
  else
    echo "Cannot configure dnf on a non-Fedora distro." &&
    exit 1
  fi
}

function configureAlacritty () {
  if ! [ -d "$HOME/.config/alacritty/" ]; then
    mkdir -vp "$HOME/.config/alacritty/"
  fi &&

  $CONFIGURE_COMMAND "./.config/alacritty/alacritty.yml" "$HOME/.config/alacritty/"
}

function configureFish () {
  if ! [ -d "$HOME/.config/fish" ]; then
    mkdir -vp "$HOME/.config/fish"
  fi &&

  $CONFIGURE_COMMAND "./.config/fish/config.fish" "$HOME/.config/fish"
}


function configureBash () {
  $CONFIGURE_COMMAND ".bashrc" "$HOME/"
}

function configure () {
  # Setting the $PACKAGE_MANAGER variable
  packageManagerFind &&

  # Finding and resolving packs
  for pack in $1; do
    case "${pack}" in
      "fedora")
        configureFedora ;;
      "fish")
        configureFish ;;
      "bash")
        configureBash ;;
      "alacritty")
        configureAlacritty ;;
    *)
      echo "One or more packs is incorrect." &&
      exit 1 ;;
    esac
  done
}


function parseArguments () {
  parsed="${1//,/ }"
}


## MAIN FUNCTION ## (cannot be in main() cuz getopts)

# Checking for arguments
if [ -z "$1" ]; then
  helpPage
fi

# Flag checking
while getopts 'hi:c:let:' flag; do
  case "${flag}" in
    h)
      helpPage &&
      exit 0 ;;
    i)
      parseArguments "$OPTARG" &&
      install "$parsed" ;;
    c)
      parseArguments "$OPTARG" &&
      configure "$parsed" ;;
    l)
      list ;;
    e)
      example &&
      exit 0 ;;
    t)
      echo "$OPTARG" &&
      exit 0 ;;
    *)
      exit 1 ;;
  esac
done
