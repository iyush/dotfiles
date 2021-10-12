# Dotfiles
## Installation
Requires =stow=, all the dependencies are installed in =install_dependies.sh=, if you want to install config only (requires =stow)=, run =./install_config.sh=

## Brightness control
Install brightnessctl and add user to the video group.

## Terminal
Use gnome terminal and compile https://github.com/schischi/xcwd for getting information on the current working directory. Launch terminal:
  ```
    gnome-terminal --working-directory="`xcwd`"
  ```
