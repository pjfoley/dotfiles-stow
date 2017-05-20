#! /bin/bash

GOOGLE_APT_LIST="/etc/apt/sources.list.d/google.list"

KEY_GOOGLE_ASC_2016="4CCA1EAF950CEE4AB83976DCA040830F7FAC5991"
GOOGLE_REPOSITORY="deb http://dl.google.com/linux/chrome/deb/ stable main"

GOOGLE_ASC_2016=$(mktemp --suffix=-google)
trap "{ rm -f ${GOOGLE_ASC_2016} ${GOOGLE_ASC}; }" EXIT

[ $(which curl) ] || sudo apt-get install -y curl

curl -sSo "${GOOGLE_ASC_2016}" https://dl.google.com/linux/linux_signing_key.pub

if [ $(gpg "${GOOGLE_ASC_2016}" 2>/dev/null | grep -s "${KEY_GOOGLE_ASC_2016}" 2>/dev/null) ]; then
  sudo apt-key --keyring "/etc/apt/trusted.gpg.d/google.gpg" add "${GOOGLE_ASC_2016}"
fi

! grep -q "^${GOOGLE_REPOSITORY}" "${GOOGLE_APT_LIST}" 2>/dev/null && echo "${GOOGLE_REPOSITORY}" | sudo tee "${GOOGLE_APT_LIST}"

sudo apt-get update

PACKAGES=( "google-chrome-stable" )

for package in "${PACKAGES[@]}"; do
  dpkg -s "${package}" >/dev/null 2>&1 && {
    echo "${package} is installed."
  } || {
    sudo apt-get install -y "${package}"
  }
done
