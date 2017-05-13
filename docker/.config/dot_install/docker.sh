#! /bin/bash

DOCKER_APT_LIST="/etc/apt/sources.list.d/docker.list"

KEY_DOCKER_ASC_2016="9DC858229FC7DD38854AE2D88D81803C0EBFCD88"
DOCKER_REPOSITORY="deb [arch=amd64] https://download.docker.com/linux/debian stretch stable"

DOCKER_ASC_2016=$(mktemp --suffix=-docker)
trap "{ rm -f ${DOCKER_ASC_2016} ${DOCKER_ASC}; }" EXIT

[ $(which curl) ] || sudo apt-get install -y curl

curl -sSo "${DOCKER_ASC_2016}" https://download.docker.com/linux/debian/gpg

if [ $(gpg "${DOCKER_ASC_2016}" 2>/dev/null | grep -s "${KEY_DOCKER_ASC_2016}" 2>/dev/null) ]; then
  sudo apt-key --keyring "/etc/apt/trusted.gpg.d/docker.gpg" add "${DOCKER_ASC_2016}"
fi

! grep -q "^${DOCKER_REPOSITORY}" "${DOCKER_APT_LIST}" 2>/dev/null && echo "${DOCKER_REPOSITORY}" | sudo tee "${DOCKER_APT_LIST}"

sudo apt-get update

PACKAGES=( "docker-ce" )

for package in "${PACKAGES[@]}"; do
  dpkg -s "${package}" >/dev/null 2>&1 && {
    echo "${package} is installed."
  } || {
    sudo apt-get install -y "${package}"
  }
done
