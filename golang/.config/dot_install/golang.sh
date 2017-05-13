#! /bin/bash

GOLANG_OPT="/opt/golang"
GOLANG_USR="/usr/local"

GOLANG_VERSION="1.8.1"
GOLANG_SHA256="a579ab19d5237e263254f1eac5352efcf1d70b9dacadb6d6bb12b0911ede8994"

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
    rm -R -f "${GOLANG_OPT}/${GOLANG_VERSION}"
    mkdir -p "${GOLANG_OPT}/${GOLANG_VERSION}"
    tar xzf "${GO_DWNLD_TEMP}" -C "${GOLANG_OPT}/${GOLANG_VERSION}"
  else
    echo "Broken download"
    exit 1
  fi
fi

[ -e "${GOLANG_USR}/go" ] && rm -R "${GOLANG_USR}/go"

ln -sf "${GOLANG_OPT}/${GOLANG_VERSION}/go" "${GOLANG_USR}/go"
