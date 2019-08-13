#! /bin/bash

GOLANG_OPT="/opt/golang"
GOLANG_USR="/usr/local"

GOLANG_VERSION="1.12.7"
GOLANG_SHA256="66d83bfb5a9ede000e33c6579a91a29e6b101829ad41fffb5c5bb6c900e109d9"

[ ! -d "${GOLANG_OPT}" ] && sudo mkdir -p "${GOLANG_OPT}"

GO_DWNLD_TEMP=$(mktemp --suffix=-golang)
trap "{ rm -f ${GO_DWNLD_TEMP}; }" EXIT

[ $(which curl) ] || sudo apt-get install -y curl

for d in $(find "${GOLANG_OPT}/" -maxdepth 1 -mindepth 1 -type d); do
  # If we have already downloaded the version we want exit script
  [ $(basename "${d}") == "${GOLANG_VERSION}" ] && ALREADY_DOWNLOADED=true
done

if [ ! $ALREADY_DOWNLOADED ]; then
  curl -s -L https://storage.googleapis.com/golang/go${GOLANG_VERSION}.linux-amd64.tar.gz \
    | tee "${GO_DWNLD_TEMP}" | sha256sum -c <(echo "${GOLANG_SHA256}  -") || rm -f "${GO_DWNLD_TEMP}"

result=$?

  if [ result ]; then
    sudo rm -R -f "${GOLANG_OPT}/${GOLANG_VERSION}"
    sudo mkdir -p "${GOLANG_OPT}/${GOLANG_VERSION}"
    sudo tar xzf "${GO_DWNLD_TEMP}" -C "${GOLANG_OPT}/${GOLANG_VERSION}"
  else
    echo "Broken download"
    exit 1
  fi
fi

[ -e "${GOLANG_USR}/go" ] && sudo rm -R "${GOLANG_USR}/go"

sudo ln -sf "${GOLANG_OPT}/${GOLANG_VERSION}/go" "${GOLANG_USR}/go"
