# pmjial's Dotfiles
This repo includes some of my dotfiles, as well as installation scripts to easily set everything up.

# Getting Started
Make sure to clone this repo into the directory called **Gitlab** located in the **/home/$USER/** like this:

``` 
git clone https://gitlab.com/Depermitto/fmonc ~/Gitlab/
```

Unfortunately this is the only directory name that works for the installation scripts. **If you do not wish to use them, clone this wherever**.

## Use installation scripts to get all the nessecary software.
This command will install all packages required to run my custom sway:
```
bash ~/Gitlab/install.sh sway
```
While this will hardlink config files from the **Gitlab** directory to the **~/.config/** in order to activate the configuration:
```
bash ~/Gitlab/configure.sh sway
```

# License
This project is licensed under the MIT License - see the LICENSE.md file for details.

# Acknowledgments
* [Nord](https://www.nordtheme.com/)
* Lokesh Krishna for their [nord-v3](https://github.com/lokesh-krishna/dotfiles/tree/main/nord-v3) configuration.
* LR Tech for their [nord.rasi](https://github.com/lr-tech/rofi-themes-collection) configuration.
