#!/bin/bash

# Installation of dependencies
echo "Installing dependencies"
echo
fedora_dependencies=(
    'gvim'                                              # GTK Vim
    'emacs'                                             # our lord and saviour
    'levien-inconsolata-fonts'                          # favourite terminal font
    'bspwm'
    'sxhkd'
    'redshift'
    'nitrogen'
    'compton'
    'ranger'
    'gnome-terminal'
    'rofi'
    'pylint'                                            # python linting
    'texlive'                                           # For tex files
    'texlive-lacheck'                                   # TeX files linting
    'syncthing'                                         # for file sync
    'stow'                                              # gnu stow
    'lxappearance'                                      # lxappearance
    'npm'						# Node package Manager 
    'node'						# Node.js
)

ubuntu_dependencies=(
    'build_essential'
    'vim-gtk3'                                              # GTK Vim
    'emacs'                                             # our lord and saviour
    'fonts-inconsolata'                          # favourite terminal font
    #'bspwm'
    #'sxhkd'
    #'redshift'
    #'nitrogen'
    #'compton'
    'ranger'
    'gnome-terminal'
    #'rofi'
    'pylint3'                                            # python linting
    'texlive'                                           # For tex files
    'texlive-lacheck'                                   # TeX files linting
    'syncthing'                                         # for file sync
    'stow'                                              # gnu stow
    #'lxappearance'                                      # lxappearance
    'npm'						# Node package Manager 
    'nodejs'						# Node.js
)

npmEssentials=(
    'tern'			                        # Tern for emacs javascript
)

polybarDependencies=(
    'cmake' 
    'gcc-c++'
    'cairo-devel' 
    'xcb-proto' 
    'xcb-util-devel' 
    'xcb-util-wm-devel'
    'xcb-util-image-devel'
    'alsa-lib-devel'
    'wireless-tools-devel'
    'libmpdclient-devel'
    'libcurl-devel'
)

OS="$(grep NAME /etc/os-release)"

NO_FORMAT="\033[0m"
C_YELLOW="\033[38;5;11m"
F_BOLD="\033[1m"

if [[ $OS == *"Ubuntu"* ]]
then
    echo -e "${F_BOLD}${C_YELLOW}Detected OS: UBUNTU ${NO_FORMAT}"
    echo
    echo -e "${F_BOLD}${C_YELLOW}Installing packages for Ubuntu. ${NO_FORMAT}"
    apt-get install -y ${ubuntu_dependencies[@]}
elif [[ $OS == *"Fedora"* ]]
then
    # Fedora package manager
    echo "Installing packages for Fedora"
    echo -e "${F_BOLD}${C_YELLOW}Detected OS: FEDORA ${NO_FORMAT}"
    echo
    echo -e "${F_BOLD}${C_YELLOW}Installing packages for Fedora. ${NO_FORMAT}"
    dnf install ${fedora_dependencies[@]}

    # Development Tools
    echo -e "${F_BOLD}${C_YELLOW}Installing developement tools for Fedora. ${NO_FORMAT}"
    dnf groupinstall "Development Tools"
    dnf groupinstall "C Development Tools"
fi

# npm
echo
echo -e "${F_BOLD}${C_YELLOW}Installing NPM Packages. ${NO_FORMAT}"
npm install -g ${npmEssentials[@]}

echo 
echo -e "${F_BO}${C_YELLOW}Building Polybar from source. ${NO_FORMAT}"
read -p "Do you want to install Polybar? [Y/n] " response
if [ ! $response -o $response = 'y' -o $response = 'Y' ]
then
    # installation of polybar
    dnf install ${polybarDependencies[@]}
    mkdir ~/build
    cd build
    cmake ..
    make -j$(nproc)
    make install
fi

echo
echo -e "${F_BOLD}${C_YELLOW}Installation complete. ${NO_FORMAT}"
echo
read -p "Do you want to setup all the config files? [Y/n] " response
if [ ! $response -o $response = 'y' -o $response = 'Y' ]
then
    chmod +x ./install_config.sh
    ./install_config.sh
fi
