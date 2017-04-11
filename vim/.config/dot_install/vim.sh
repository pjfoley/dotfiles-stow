#! /bin/bash

PACKAGES=( "vim-nox" "python-pip" "powerline" " fonts-powerline")

for package in "${PACKAGES[@]}"; do
    dpkg -s "${package}" >/dev/null 2>&1 && {
        echo "${package} is installed."
    } || {
        sudo apt-get install -y "${package}"
    }
done
