#! /bin/bash

OPT_APP_PATH="/opt/terraform"

WWW_TERRAFORM_VERSION="0.12.6"

[ ! -d "${OPT_APP_PATH}" ] && sudo mkdir -p "${OPT_APP_PATH}"

DWNLD_TEMP=$(mktemp --suffix=-terraform)
trap "{ rm -f ${DWNLD_TEMP}; }" EXIT

[ $(which curl) ] || sudo apt-get install -y curl

for d in $(find "${OPT_APP_PATH}/" -maxdepth 1 -mindepth 1 -type d); do
  # If we have already downloaded the version we want exit script
  [ $(basename "${d}") == "${WWW_TERRAFORM_VERSION}" ] && ALREADY_DOWNLOADED=true
done

if [ ! $ALREADY_DOWNLOADED ]; then
  curl -s -L https://releases.hashicorp.com/terraform/${WWW_TERRAFORM_VERSION}/terraform_${WWW_TERRAFORM_VERSION}_linux_amd64.zip \
    -o ${DWNLD_TEMP}

result=$?

  if [ result ]; then
    sudo rm -R -f "${OPT_APP_PATH}/${WWW_TERRAFORM_VERSION}"
    sudo mkdir -p "${OPT_APP_PATH}/${WWW_TERRAFORM_VERSION}"
    sudo unzip -q "${DWNLD_TEMP}" -d "${OPT_APP_PATH}/${WWW_TERRAFORM_VERSION}"
  else
    echo "Broken download"
    exit 1
  fi
fi

sudo ln -sf "${OPT_APP_PATH}/${WWW_TERRAFORM_VERSION}" "${OPT_APP_PATH}/latest"
"${OPT_APP_PATH}/latest/terraform" -install-autocomplete
