#!/bin/bash

# Installation of dependencies

echo "Installing dependencies"
echo
dependencies=(
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
# Fedora package manager
sudo dnf install ${dependencies[@]}
echo 
#echo "Do you want to install Polybar? [Y/n]"
read -p "Do you want to install Polybar? [Y/n] " response
if [ ! $response -o $response = 'y' -o $response = 'Y' ]
then
    # installation of polybar
    sudo dnf install ${polybarDependencies[@]}
    mkdir ~/build
    cd build
    cmake ..
    make -j$(nproc)
    sudo make install
fi

echo
echo "Installation complete"
