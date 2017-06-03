#! /bin/bash

PACKAGES=( "i3" "i3blocks" "i3status" "i3lock" "rofi" "lightdm" "suckless-tools" "rxvt-unicode-256color" "x11-xserver-utils" "xclip" "nfs-common" "sakura" )

for package in "${PACKAGES[@]}"; do
    dpkg -s "${package}" >/dev/null 2>&1 && {
        echo "${package} is installed."
    } || {
        sudo apt-get install -y "${package}"
    }
done
