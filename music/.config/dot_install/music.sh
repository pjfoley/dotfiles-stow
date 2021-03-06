#! /bin/bash

PACKAGES=( "alsa-utils" "alsa-oss" "alsamixergui" "pulseaudio" "mpd" "mpc" "mpv" "ncmpcpp" "pavucontrol")

for package in "${PACKAGES[@]}"; do
    dpkg -s "${package}" >/dev/null 2>&1 && {
        echo "${package} is installed."
    } || {
        sudo apt-get install -y "${package}"
    }
done
