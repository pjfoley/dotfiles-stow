#! /bin/bash

BIN_LOC="/usr/local/bin"
GITHUB_CLI_OPT="/opt/github-cli"

WWW_GITHUB_CLI_VERSION=$(curl -L -s -H 'Accept: application/json' https://github.com/cli/cli/releases/latest | sed -e 's/.*"tag_name":"v\([^"]*\)".*/\1/')

[ ! -d "${GITHUB_CLI_OPT}" ] && sudo mkdir -p "${GITHUB_CLI_OPT}"
[ ! -d "${BIN_LOC}" ] && sudo mkdir -p "${BIN_LOC}"

DWNLD_TEMP=$(mktemp --suffix=-golang)
trap "{ rm -f ${DWNLD_TEMP}; }" EXIT

[ $(which curl) ] || sudo apt-get install -y curl

for d in $(find "${GITHUB_CLI_OPT}/" -maxdepth 1 -mindepth 1 -type d); do
  # If we have already downloaded the version we want exit script
  [ $(basename "${d}") == "${WWW_GITHUB_CLI_VERSION}" ] && ALREADY_DOWNLOADED=true
done

if [ ! $ALREADY_DOWNLOADED ]; then
  curl -s -L https://github.com/cli/cli/releases/download/v${WWW_GITHUB_CLI_VERSION}/gh_${WWW_GITHUB_CLI_VERSION}_linux_amd64.tar.gz \
   -o "${DWNLD_TEMP}"

result=$?

  if [ result ]; then
    sudo rm -R -f "${GITHUB_CLI_OPT}/${WWW_GITHUB_CLI_VERSION}"
    sudo mkdir -p "${GITHUB_CLI_OPT}/${WWW_GITHUB_CLI_VERSION}"
    sudo tar xzf "${DWNLD_TEMP}" --strip 1 -C "${GITHUB_CLI_OPT}/${WWW_GITHUB_CLI_VERSION}"
  else
    echo "Broken download"
    exit 1
  fi
fi

sudo ln -sf "${GITHUB_CLI_OPT}/${WWW_GITHUB_CLI_VERSION}/bin/gh" "${BIN_LOC}/gh"
