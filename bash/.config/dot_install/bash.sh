#! /bin/bash

PACKAGES=("bash-completion" "python-pip" "powerline" "fonts-powerline" "curl" "wget" "man" "jq" "bc")

for package in "${PACKAGES[@]}"; do
    dpkg -s "${package}" >/dev/null 2>&1 && {
        echo "${package} is installed."
    } || {
        sudo apt-get install -y "${package}"
    }
done
