#! /usr/bin/env bash

# abort on nonzero exitstatus
set -o errexit
# dont hide errors within pipes
set -o pipefail

# The directory where current script resides
readonly SCRIPT_DIR=$(dirname $(readlink -f "${BASH_SOURCE[0]}" 2>/dev/null||echo $0))
# The directory where the bash libraries are
pushd "$SCRIPT_DIR" > /dev/null && BASHLIB="$(readlink -f ./$(git rev-parse --show-cdup))/.bashlib" && popd > /dev/null


[ -z "${COLOUR_BLUE}" ] || [ -z "${COLOUR_DKRED}"] && . "${BASHLIB}/script_utils.sh"

# abort on unbound variable
set -o nounset

unset optname && readonly optname="/opt/tfhelper"
unset ghrepo && readonly ghrepo="hashicorp-community/tf-helper"
unset artefactfilter && readonly artefactfilter="zipball"

readonly tmp_dir=$(mktemp -d -t msg.XXXXXXXXX)
trap "rm -rf ${tmp_dir}" EXIT ERR

# Create location for application in Opt
[ ! -d "${optname}" ] && mkdir -p "${optname}"

# Only continue if the directory does not exist, as we will need to create symbolic links
if [ -e "${optname}/latest" ] && [ ! -h "${optname}/latest" ]; then
  echo "Directory already exists err err"
  exit 1
fi

# Get tag to install and URL
read rtval ver url < <(echo $("${BASHLIB}/ghtag.sh" --repo "${ghrepo}" --search "${artefactfilter}" --tmpdir "${tmp_dir}"))
if [[ $rtval -gt 0 ]]; then
  echo "Errored out"; exit 1
  unset rtval
fi

if [ ! -d "${optname}/${ver}" ]; then
  read rtval fn < <(echo $("${BASHLIB}/get_artefact.sh" --url "${url}" --tmpdir "${tmp_dir}" ))
  [[ $rtval -gt 0 ]] && ( echo "Errored out"; exit 1)
  unset rtval

  readonly topdir=$(zipinfo -1 "${fn}" "*/" | head -1)
  unzip -q "${fn}" -d "${tmp_dir}"

  mkdir -p -- "${optname}/${ver}"
  ( shopt -s dotglob && mv "${tmp_dir}/${topdir}"* "${optname}/${ver}" )
fi

if [[ $(readlink -f "${optname}/${ver}") = $(readlink -f "${optname}/latest") ]]; then
  echo "Same nothing to do";
  exit 0
fi

[ -h "${optname}/latest" ] && unlink "${optname}/latest"

ln -sf $(readlink -f "${optname}/${ver}") $(readlink -f "${optname}/latest")

# echo "exists '${optname}/${ver}'"; exit 1

# read http_status ver url < <(echo $(gh_latest "boo/hoo" "linux_amd64.deb"))
# read http_status ver url < <(echo $(gh_latest "cli/cli" "linux_amd64.deb"))
# read http_status ver url < <(echo $(gh_latest "GoogleContainerTools/skaffold" "linux-amd64"))

