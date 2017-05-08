#! /bin/bash

BIN_LOC="/usr/local/bin"
DWN_LOC="/opt/kubernetes"

[ ! -d "${BIN_LOC}" ] && sudo mkdir -p "${BIN_LOC}"
[ ! -d "${DWN_LOC}" ] && sudo mkdir -p "${DWN_LOC}"

[ $(which curl) ] || sudo apt-get install -y curl

WWW_KUBECTL_VERSION=$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)
WWW_MINIKUBE_VERSION=$(curl -L -s -H 'Accept: application/json' https://github.com/kubernetes/minikube/releases/latest | sed -e 's/.*"tag_name":"\([^"]*\)".*/\1/')

[[ $("${BIN_LOC}/kubectl" version 2>/dev/null | sed -e 's/.*GitVersion:"\([^"]*\)".*/\1/') \
  != "${WWW_KUBECTL_VERSION}" ]] \
  && KUBECTL_DOWNLOAD=true

[[ "$("${BIN_LOC}/minikube" version 2>/dev/null | sed 's/.*: //')" \
  != "${WWW_MINIKUBE_VERSION}" ]] \
  && MINIKUBE_DOWNLOAD=true

if [ ! -x "${BIN_LOC}/kubectl" ] || [ true == "${KUBECTL_DOWNLOAD}" ]; then
  sudo  curl -sS https://storage.googleapis.com/kubernetes-release/release/${WWW_KUBECTL_VERSION}/bin/linux/amd64/kubectl \
    -o ${DWN_LOC}/kubectl-${WWW_KUBECTL_VERSION} \
    && sudo chmod +x ${DWN_LOC}/kubectl-${WWW_KUBECTL_VERSION} \
    && sudo ln -fs "${DWN_LOC}/kubectl-${WWW_KUBECTL_VERSION}" "${BIN_LOC}/kubectl"
fi

if [ ! -x "${BIN_LOC}/minikube" ] || [ true == "${MINIKUBE_DOWNLOAD}" ]; then
  sudo  curl -sS https://storage.googleapis.com/minikube/releases/${WWW_MINIKUBE_VERSION}/minikube-linux-amd64 \
    -o ${DWN_LOC}/minikube-${WWW_MINIKUBE_VERSION} \
    && sudo chmod +x ${DWN_LOC}/minikube-${WWW_MINIKUBE_VERSION} \
    && sudo ln -fs "${DWN_LOC}/minikube-${WWW_MINIKUBE_VERSION}" "${BIN_LOC}/minikube"
fi

