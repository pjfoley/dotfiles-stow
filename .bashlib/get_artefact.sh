#! /usr/bin/env bash

[ -z "${COLOUR_BLUE}" ] || [ -z "${COLOUR_DKRED}" ] && . $(dirname "${BASH_SOURCE[0]}")/script_utils.sh

# abort on nonzero exitstatus
set -o errexit
# abort on unbound variable
set -o nounset
# dont hide errors within pipes
set -o pipefail

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
  local -r artefact=${2-}
  printf "$rtrval $artefact\n"
  exit $1
}

function get_artefact() {

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
    URL:             ${URL}
    Scratch File:    ${TMP_FILE}
EOF
)
   log "${log_msg}"

  log "Execute task to get artefact version and URL"
  execute_tasks

  errval=$?

  [[ "${errval}" -gt 0 ]] && sendvalues 4

  sendvalues 0 "${TMP_FILE}"

  exit 0
}


## -----------------------------------------------------------------------------
## Perform tasks to execute.
## -----------------------------------------------------------------------------
execute_tasks() {
# URL to artefact:               ${URL} 
# Scratch File:                  ${TMP_FILE}

# https://gist.github.com/steinwaywhw/a4cd19cda655b8249d908261a62687f8

  local -r http_response=$(curl -L --silent --output "${TMP_FILE}" --write-out '%{http_code}' "${URL}" )

  if [[ $http_response != "200" ]]; then
    warning "'${http_response}' response curling '${URL}'"
    return 1
  fi

  return 0
}

show_usage() {
  printf "Usage: ghrelease [OPTION...]\n" >&2
  printf "  -d, --debug\t\tLog messages while processing\n" >&2
  printf "  -h, --help\t\tShow this help message then exit\n" >&2
  printf "  -u, --url\t\tURL to the artefact to download\n" >&2
  printf "  --tmp\t\tFolder to store downloaded artefact in, deletion resposibiity with the caller\n" >&2
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
       -u|--url)
        readonly ARG_URL="$2"
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
}

function required_arguments() {
  local missing=0

   if [ ! "${ARG_URL:-}" ]; then
     warning '--URL must be provided'
     missing=$(( missing + 1 ))
   fi

  ARGUMENT_MISSING=$missing
}

function setup_for_work() {
   readonly URL="${ARG_URL}"

   # if [[ ! "${ARG_TMPDIR:-}" ]] && [[ ! -d "${ARG_TMPDIR:-}" ]]; then
   if [[ ! -d "${ARG_TMPDIR:-}" ]]; then
     readonly TMP_FILE=$(mktemp -t artefact.XXXXXXXXX)
     warning "Please delete when finished: '${TMP_FILE}'"
   else
     readonly TMP_FILE=$(mktemp --tmpdir="${ARG_TMPDIR}" -t artefact.XXXXXXXXX)
   fi
}

if [ "${BASH_SOURCE[0]}" != "${0}" ]; then
    export -f get_artefact
  else
    get_artefact "${@}"
    exit $?
fi
