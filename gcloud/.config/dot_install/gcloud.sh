#! /bin/bash

OPT_APP_PATH="/opt/gcloud"

WWW_GCLOUD_VERSION="278.0.0"

[ ! -d "${OPT_APP_PATH}" ] && sudo mkdir -p "${OPT_APP_PATH}"

DWNLD_TEMP=$(mktemp --suffix=-gcloud)
trap "{ rm -f ${DWNLD_TEMP}; }" EXIT

[ $(which curl) ] || sudo apt-get install -y curl

for d in $(find "${OPT_APP_PATH}/" -maxdepth 1 -mindepth 1 -type d); do
  # If we have already downloaded the version we want exit script
  [ $(basename "${d}") == "${WWW_GCLOUD_VERSION}" ] && ALREADY_DOWNLOADED=true
done

if [ ! $ALREADY_DOWNLOADED ]; then
  curl -s -L https://storage.googleapis.com/cloud-sdk-release/google-cloud-sdk-${WWW_GCLOUD_VERSION}-linux-x86_64.tar.gz \
    -o ${DWNLD_TEMP}

result=$?

  if [ result ]; then
    sudo rm -R -f "${OPT_APP_PATH}/${WWW_GCLOUD_VERSION}"
    sudo mkdir -p "${OPT_APP_PATH}/${WWW_GCLOUD_VERSION}"
    sudo tar xzf "${DWNLD_TEMP}" --strip 1 -C "${OPT_APP_PATH}/${WWW_GCLOUD_VERSION}"
  else
    echo "Broken download"
    exit 1
  fi
fi

sudo ln -sf "${OPT_APP_PATH}/${WWW_GCLOUD_VERSION}" "${OPT_APP_PATH}/latest"
