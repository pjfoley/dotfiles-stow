#! /usr/bin/env bash

[ -z "${COLOUR_BLUE}" ] || [ -z "${COLOUR_DKRED}"] && . $(dirname "${BASH_SOURCE[0]}")/script_utils.sh

# abort on nonzero exitstatus
set -o errexit
# abort on unbound variable
set -o nounset
# dont hide errors within pipes
set -o pipefail

readonly GH_API_URL="https://api.github.com"

# printf "ghrelease\n"
# printf '\t$0 is: %s\n\t$BASH_SOURCE is: %s\n' "$0" "$BASH_SOURCE"
# printf '\t$BASH_SOURCE[@] is: %s\n' "${BASH_SOURCE[@]}"

# Ensure pre-existing values do not affect the script
# Set to default value
unset ARG_HELP && ARG_HELP=""
unset ARG_DEBUG && ARG_DEBUG=""
unset REQUIRED_MISSING && REQUIRED_MISSING=0
unset ARGUMENT_MISSING && ARGUMENT_MISSING=0

unset ARCHIVE_VERSION && ARCHIVE_VERSION=""
unset ARCHIVE_URL && ARCHIVE_URL=""

function sendvalues() {
  local -r rtrval=$1
  local -r archive_version="${2-}"
  local -r archive_url="${3-}"
  printf "$rtrval $archive_version $archive_url\n"
  exit $1
}

function ghrelease() {
# local -r SCRIPT_SRC="$(dirname "${BASH_SOURCE[0]}")"
# local -r SCRIPT_DIR="$(cd "$SCRIPT_SRC" >/dev/null 2>&1 && pwd)"
# local -r SCRIPT_NAME=$(basename "$0")



  parse_commandline "$@"

  [[ -n "${ARG_HELP}" ]] && ( show_usage; sendvalues 3 )

  log "Check for missing software requirements"
  validate_requirements
  [[ "${REQUIRED_MISSING}" -gt 0 ]] && sendvalues 4

  log "Check for missing argument requirements"
  required_arguments
  [[ "${ARGUMENT_MISSING}" -gt 0 ]] && sendvalues 4

  log "Setup variables pre-executing task"
  setup_for_work

   local -r log_msg=$(cat <<-EOF
Variables Setup for execute task
    URL:             ${GH_API_URL}${GH_API_URI}
    Search Criteria: ${SEARCH_CRITERIA} 
    Search Tag:      ${SEARCH_TAG} 
    Scratch File:    ${TMP_FILE}
EOF
)
   log "${log_msg}"



  log "Execute task to get artefact version and URL"
  execute_tasks

  errval=$?


  [[ "${errval}" -gt 0 ]] && sendvalues 4

  sendvalues 0 "${ARCHIVE_VERSION}" "${ARCHIVE_URL}"

  exit 0
}


## -----------------------------------------------------------------------------
## Perform tasks to execute.
## -----------------------------------------------------------------------------
execute_tasks() {
# URL to hit:                    ${GH_API_URL}${GH_API_URI}
# Search Criteria for file type: ${SEARCH_CRITERIA} 
# Search Tag:                    ${SEARCH_TAG} 
# Scratch File:                  ${TMP_FILE}

# https://gist.github.com/steinwaywhw/a4cd19cda655b8249d908261a62687f8

  local -r http_response=$(curl -L --silent --output "${TMP_FILE}" --write-out '%{http_code}' "${GH_API_URL}${GH_API_URI}" )

  if [[ $http_response != "200" ]]; then
    warning "'${http_response}' response curling GITHUB API @ '${GH_API_URL}${GH_API_URI}"
    return 1
  fi

  read ARCHIVE_VERSION ARCHIVE_URL < <(echo $(jq -r '.tag_name, (.assets | map({content_type, name, browser_download_url} | select(.name | contains("'"${SEARCH_CRITERIA}"'"))) | .[0].browser_download_url)' "${TMP_FILE}"))

  if [ "x${ARCHIVE_VERSION}" = "x" ]; then
    warning "Warning: Could not get an archive version or url you are looking for from the GITHUB API @ '${GH_API_URL}${GH_API_URI}"
    exit 1
  fi

  readonly ARCHIVE_VERSION ARCHIVE_URL
  return 0
}

show_usage() {
  printf "Usage: ghrelease [OPTION...]\n" >&2
  printf "  -d, --debug\t\tLog messages while processing\n" >&2
  printf "  -h, --help\t\tShow this help message then exit\n" >&2
  printf "  -r, --repo\t\tGithub Repo to hit in the form of {owner}\{repository}\n" >&2
  printf "  -s, --search\t\tSearch critiera for file, for example linux_amd64.deb\n" >&2
  printf "  -t, --tag\t\tGit tag, if none provided will default to {latest}\n" >&2
  printf "  --tmpdir\t\tFolder to store temporary files in, if provided deletion resposibiity with the caller\n" >&2
}

function parse_commandline() {
  while [ "$#" -gt "0" ]; do
    local consume=1

    case "$1" in
     -h|-\?|--help)
        readonly ARG_HELP="true"
      ;;
      -d|--debug)
        readonly ARG_DEBUG="true"
      ;;
       -r|--repo)
        readonly ARG_REPO="$2"
        consume=2
      ;;
      -s|--search)
        readonly ARG_SEARCH="$2"
        consume=2
      ;;
      -t|--tag)
        readonly ARG_TAG="$2"
        consume=2
      ;;
      --tmpdir)
        readonly ARG_TMPDIR="$2"
        consume=2
      ;;
         *)
        # Skip argument
      ;;
    esac

    shift ${consume}
  done
}

function validate_requirements() {
  required curl "https://curl.haxx.se/docs/manpage.html"
  required jq "https://stedolan.github.io/jq/manual/"
}

function required_arguments() {
  local missing=0


   if [ ! "${ARG_SEARCH:-}" ] ; then
     warning '--search must be provided to narrow down artefact'
     missing=$(( missing + 1 ))
   fi

   if [ ! "${ARG_REPO:-}" ]; then
     warning '--repo must be provided'
     missing=$(( missing + 1 ))
   fi

   if [ "${ARG_TMPDIR:-}" ] && [[ ! -d "${ARG_TMPDIR}" ]]; then
     warning '--tmpdir must be a directory and exist'
     missing=$(( missing + 1 ))
   fi

  ARGUMENT_MISSING=$missing
}

function setup_for_work() {
   readonly SEARCH_CRITERIA="${ARG_SEARCH}"
   readonly SEARCH_TAG="${ARG_TAG-latest}"

   [ "latest" = "${SEARCH_TAG}" ] && readonly GH_API_URI="/repos/${ARG_REPO}/releases/${SEARCH_TAG}" \
                                  || readonly GH_API_URI="/repos/${ARG_REPO}/releases/tags/${SEARCH_TAG}"

   if [[ ! "${ARG_TMPDIR:-}" ]]; then
     readonly TMP_FILE=$(mktemp -t ghrelease.XXXXXXXXX)
     trap "rm -rf ${TMP_FILE}" EXIT ERR
   else
     readonly TMP_FILE=$(mktemp --tmpdir="${ARG_TMPDIR}" -t ghrelease.XXXXXXXXX)
   fi

}

if [ "${BASH_SOURCE[0]}" != "${0}" ]; then
    export -f ghrelease
  else
    ghrelease "${@}"
    exit $?
fi
