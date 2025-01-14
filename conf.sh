#!/bin/bash
# Copyright (C) 2024 Jabłoński "Permito" Piotr

render_menu() {
    for ((i = 0; i < "${#options[@]}"; i++)); {
        
        if [[ "${selected[$i]}" == true ]]; then
            local icon="X"
        else
            local icon=" "
        fi
        
        if [[ "$cursor" == "$i" ]]; then
            local line_icon=">"
        else
            local line_icon=" "
        fi
        
        echo -e "\r $line_icon [$icon] ${options[$i]}"
    }
    
    printf '\e[%dA' "${#options[@]}" # move a couple of lines up to render the next frame on top
}

perform_action() {
    case $1 in
        zshrc)
            cp -vi .zshrc ~/.zshrc
            [[ $? -eq 1 ]] && {
                echo "zshrc - cancelled."
                return 1
            }
            
            cp -vrf .local/share/powerlevel10k ~/.local/share/
            [[ $? -eq 1 ]] && {
                echo "powerlevel10k - cancelled."
                return 1
            }
            
            cp -v .p10k.zsh ~/
            [[ $? -eq 1 ]] && {
                echo "p10k.zsh - cancelled."
                return 1
            }
        ;;
        bashrc)
            cp -vi .bashrc ~/.bashrc
            [[ $? -eq 1 ]] && {
                echo "bashrc - cancelled."
                return 1
            }
        ;;
        fish)
            cp -vri .config/fish/ ~/.config/
            [[ $? -eq 1 ]] && {
                echo "fish - cancelled."
                return 1
            }
        ;;
        dnfconf)
            sudo cp -vi ./etc/dnf/dnf.conf /etc/dnf/dnf.conf
            [[ $? -eq 1 ]] && {
                echo "dnfconf - cancelled."
                return 1
            }
        ;;
        pacmanconf)
            sudo cp -vi ./etc/pacman.conf /etc/pacman.conf
            [[ $? -eq 1 ]] && {
                echo "pacmanconf - cancelled."
                return 1
            }
        ;;
        flathub)
            if which flatpak 1> /dev/null 2> /dev/null; then
                echo "flatpak already installed."
            else
                sudo "$install_cmd" flatpak
                [[ $? -eq 1 ]] && {
                    echo "installing flathub - cancelled."
                    return 1
                }
            fi
            
            if flatpak remotes | grep -q flathub; then
                echo "remote flathub already exists."
                return 0
            fi
            
            if flatpak --user remote-add flathub https://dl.flathub.org/repo/flathub.flatpakrepo 2> /dev/null 1> /dev/null; then
                echo "added flathub."
            fi
        ;;
        ssh_askpass)
            cp -vir .config/environment.d/ ~/.config/
            [[ $? -eq 1 ]] && {
                echo "cancelled."
                return 1
            }
        ;;
        *)
            echo "$1 - not implemented yet!"
        ;;
    esac
}

handle_key() {
    case $1 in
        q) exit 0 ;;
        j)
            local limit=${#options[@]}
            ((limit--)) # bash arrays start from index 0
            if [[ $cursor -ge $limit ]]; then
                ((cursor=limit))
            else
                ((cursor++))
            fi
        ;;
        k)
            if [[ $cursor -le 0 ]]; then
                ((cursor=0))
            else
                ((cursor--))
            fi
        ;;
        # captures [ENTER] and [SPACE]
        "")
            if [[ "${selected[$cursor]}" == true ]]; then
                selected[cursor]=false
            else
                selected[cursor]=true
            fi
        ;;
        a)
            for ((i = 0; i < "${#selected[@]}"; i++)); {
                selected[i]=true
            }
        ;;
        n)
            for ((i = 0; i < "${#selected[@]}"; i++)); {
                selected[i]=false
            }
        ;;
        d | y)
            cleanup
            for ((i = 0; i < "${#selected[@]}"; i++)); {
                [[ "${selected[$i]}" == true ]] && {
                    perform_action "${options[$i]}"
                }
            }
            exit 0
        ;;
    esac
}

cleanup() {
    printf '\e[?25h' # show cursor
    printf '\e[%dB' "${#options[@]}" # move exactly ${#options[@]} lines up to render the next frame on top
}

main() {
    printf '\e[?25l' # hide cursor
    trap 'cleanup' EXIT
    
    cursor=0
    options=("zshrc" "bashrc" "fish" "dnfconf" "pacmanconf" "flathub" "ssh_askpass")
    for ((i = 0; i < "${#options[@]}"; i++)); { selected+=(false); }
    
    # finding the package manager
    for p in "apt" "dnf" "pacman"; {
        if which $p 1> /dev/null 2> /dev/null; then
            case $p in
                apt | dnf)
                    install_cmd="$p install"
                ;;
                pacman)
                    install_cmd="$p -Sy"
                ;;
            esac
        fi
    }
    
    [[ $install_cmd == "" ]] && {
        # text on red background
        printf "\e[1;41mUnsupported package manager, the script will not be able to install packages\e[0m\n"
    }
    
    echo "[j=down, k=up, space/enter=toggle, a=all, n=none, d/y=done, q=abort]"
    echo "Which actions would you like to perform?"
    
    for ((;;)); {
        render_menu
        read -rsn 1 key
        handle_key "$key"
    }
}

main "$@"
