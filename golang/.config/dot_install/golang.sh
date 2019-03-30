#! /bin/bash

GOLANG_OPT="/opt/golang"
GOLANG_USR="/usr/local"

# GOLANG_VERSION="1.8.1"
# GOLANG_SHA256="a579ab19d5237e263254f1eac5352efcf1d70b9dacadb6d6bb12b0911ede8994"

# GOLANG_VERSION="1.9.2"
# GOLANG_SHA256="de874549d9a8d8d8062be05808509c09a88a248e77ec14eb77453530829ac02b"

# GOLANG_VERSION="1.10.2"
# GOLANG_SHA256="4b677d698c65370afa33757b6954ade60347aaca310ea92a63ed717d7cb0c2ff"

# GOLANG_VERSION="1.11"
# GOLANG_SHA256="b3fcf280ff86558e0559e185b601c9eade0fd24c900b4c63cd14d1d38613e499"

GOLANG_VERSION="1.11.4"
GOLANG_SHA256="fb26c30e6a04ad937bbc657a1b5bba92f80096af1e8ee6da6430c045a8db3a5b"

GOLANG_VERSION="1.12"
GOLANG_SHA256="750a07fef8579ae4839458701f4df690e0b20b8bcce33b437e4df89c451b6f13"

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
