#! /bin/bash

BIN_LOC="/usr/local/bin"
DWN_LOC="/opt/skaffold"

[ ! -d "${BIN_LOC}" ] && sudo mkdir -p "${BIN_LOC}"
[ ! -d "${DWN_LOC}" ] && sudo mkdir -p "${DWN_LOC}"

[ $(which curl) ] || sudo apt-get install -y curl

WWW_SKAFFOLD_VERSION=$(curl -L -s -H 'Accept: application/json' https://github.com/GoogleContainerTools/skaffold/releases/latest | sed -e 's/.*"tag_name":"\([^"]*\)".*/\1/')

[[ "$("${BIN_LOC}/skaffold" version 2>/dev/null | sed 's/.*: //')" \
  != "${WWW_SKAFFOLD_VERSION}" ]] \
  && SKAFFOLD_DOWNLOAD=true

if [ ! -x "${BIN_LOC}/skaffold" ] || [ true == "${SKAFFOLD_DOWNLOAD}" ]; then
  sudo  curl -sS https://storage.googleapis.com/skaffold/releases/${WWW_SKAFFOLD_VERSION}/skaffold-linux-amd64 \
    -o ${DWN_LOC}/skaffold-${WWW_SKAFFOLD_VERSION} \
    && sudo chmod +x ${DWN_LOC}/skaffold-${WWW_SKAFFOLD_VERSION} \
    && sudo ln -fs "${DWN_LOC}/skaffold-${WWW_SKAFFOLD_VERSION}" "${BIN_LOC}/skaffold"
fi
