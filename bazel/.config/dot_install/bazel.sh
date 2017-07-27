#! /bin/bash

BAZEL_APT_LIST="/etc/apt/sources.list.d/bazel.list"

KEY_BAZEL_ASC_2016="71A1D0EFCFEB6281FD0437C93D5919B448457EE0"
BAZEL_REPOSITORY="deb [arch=amd64] http://storage.googleapis.com/bazel-apt stable jdk1.8"

BAZEL_ASC_2016=$(mktemp --suffix=-bazel)
trap "{ rm -f ${BAZEL_ASC_2016} ${BAZEL_ASC}; }" EXIT

[ $(which curl) ] || sudo apt-get install -y curl

curl -sSo "${BAZEL_ASC_2016}" https://bazel.build/bazel-release.pub.gpg

if [ $(gpg "${BAZEL_ASC_2016}" 2>/dev/null | grep -s "${KEY_BAZEL_ASC_2016}" 2>/dev/null) ]; then
  sudo apt-key --keyring "/etc/apt/trusted.gpg.d/bazel.gpg" add "${BAZEL_ASC_2016}"
fi

! grep -q "^${BAZEL_REPOSITORY}" "${BAZEL_APT_LIST}" 2>/dev/null && echo "${BAZEL_REPOSITORY}" | sudo tee "${BAZEL_APT_LIST}"

sudo apt-get update

PACKAGES=( "bazel" )

for package in "${PACKAGES[@]}"; do
  dpkg -s "${package}" >/dev/null 2>&1 && {
    echo "${package} is installed."
  } || {
    sudo apt-get install -y "${package}"
  }
done
