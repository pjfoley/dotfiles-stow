#! /bin/bash

VIRTBOX_APT_LIST="/etc/apt/sources.list.d/virtualbox.list"

KEY_VIRTBX_ASC_2016="B9F8D658297AF3EFC18D5CDFA2F683C52980AECF"
VIRTUALBOX_REPOSITORY="deb http://download.virtualbox.org/virtualbox/debian stretch contrib"

VIRTBX_ASC_2016=$(mktemp --suffix=-virtualbox)
trap "{ rm -f ${VIRTBX_ASC_2016} ${VIRTBX_ASC}; }" EXIT

[ $(which curl) ] || sudo apt-get install -y curl

curl -sSo "${VIRTBX_ASC_2016}" https://www.virtualbox.org/download/oracle_vbox_2016.asc

if [ $(gpg "${VIRTBX_ASC_2016}" 2>/dev/null | grep -s "${KEY_VIRTBX_ASC_2016}" 2>/dev/null) ]; then
  sudo apt-key --keyring "/etc/apt/trusted.gpg.d/virtualbox.gpg" add "${VIRTBX_ASC_2016}"
fi

! grep -q "^${VIRTUALBOX_REPOSITORY}" "${VIRTBOX_APT_LIST}" 2>/dev/null && echo "${VIRTUALBOX_REPOSITORY}" | sudo tee "${VIRTBOX_APT_LIST}"

sudo apt-get update

PACKAGES=( "linux-headers-amd64" "virtualbox-5.1" "dkms" )

for package in "${PACKAGES[@]}"; do
  dpkg -s "${package}" >/dev/null 2>&1 && {
    echo "${package} is installed."
  } || {
    sudo apt-get install -y "${package}"
  }
done
