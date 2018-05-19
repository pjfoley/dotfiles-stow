#! /bin/bash

OPT_APP_PATH="/opt/istio"
GOLANG_USR="/usr/local"

WWW_ISTIO_VERSION=$(curl -L -s -H 'Accept: application/json' https://github.com/istio/istio/releases/latest | jq '.tag_name' | tr -d '"')

[ ! -d "${OPT_APP_PATH}" ] && sudo mkdir -p "${OPT_APP_PATH}"

DWNLD_TEMP=$(mktemp --suffix=-istio)
trap "{ rm -f ${DWNLD_TEMP}; }" EXIT

[ $(which curl) ] || sudo apt-get install -y curl

for d in $(find "${OPT_APP_PATH}/" -maxdepth 1 -mindepth 1 -type d); do
  # If we have already downloaded the version we want exit script
  [ $(basename "${d}") == "${WWW_ISTIO_VERSION}" ] && ALREADY_DOWNLOADED=true
done

if [ ! $ALREADY_DOWNLOADED ]; then
  curl -s -L https://github.com/istio/istio/releases/download/${WWW_ISTIO_VERSION}/istio-${WWW_ISTIO_VERSION}-linux.tar.gz \
    -o ${DWNLD_TEMP}

result=$?

  if [ result ]; then
    sudo rm -R -f "${OPT_APP_PATH}/${WWW_ISTIO_VERSION}"
    sudo mkdir -p "${OPT_APP_PATH}/${WWW_ISTIO_VERSION}"
    sudo tar xzf "${DWNLD_TEMP}" --strip 1 -C "${OPT_APP_PATH}/${WWW_ISTIO_VERSION}"
  else
    echo "Broken download"
    exit 1
  fi
fi

sudo ln -sf "${OPT_APP_PATH}/${WWW_ISTIO_VERSION}" "${OPT_APP_PATH}/latest"
