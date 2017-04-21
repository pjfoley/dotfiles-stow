#! /bin/bash

PACKAGES=( "vlc" "unzip" "rar" "unrar" "thunar" "zathura" "cifs-utils" "smbclient" "silversearcher-ag" "diodon" "exuberant-tags" "compton" "lxappearance" "feh" "freerdp-x11")

for package in "${PACKAGES[@]}"; do
    dpkg -s "${package}" >/dev/null 2>&1 && {
        echo "${package} is installed."
    } || {
        sudo apt-get install -y "${package}"
    }
done
