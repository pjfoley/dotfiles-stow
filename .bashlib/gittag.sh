#! /usr/bin/env bash

[ -z "${COLOUR_BLUE}" ] || [ -z "${COLOUR_DKRED}"] && . $(dirname "${BASH_SOURCE[0]}")/script_utils.sh

# abort on nonzero exitstatus
set -o errexit
# abort on unbound variable
set -o nounset
# dont hide errors within pipes
set -o pipefail

# readonly SCRIPT_SRC="$(dirname "${BASH_SOURCE[0]}")"
# readonly SCRIPT_DIR="$(cd "$SCRIPT_SRC" >/dev/null 2>&1 && pwd)"
# readonly SCRIPT_NAME=$(basename "$0")

declare -a -r TAG_SUFFIX=("dev" "alpha" "beta" "rc")
declare -a GIT_SEARCH_SUFFIX
for tag in ${TAG_SUFFIX[@]}
do
                          # versionsort.suffix=-alpha
 GIT_SEARCH_SUFFIX+=( "versionsort.suffix=${tag}" "versionsort.suffix=-${tag}" )
done
readonly GIT_SEARCH_SUFFIX

declare -a IGNORE_PRERELEASES
for tag in ${TAG_SUFFIX[@]}
do
 IGNORE_PRERELEASES+="${tag}\|"
done
IGNORE_PRERELEASES="${IGNORE_PRERELEASES%\\|}"
readonly IGNORE_PRERELEASES


# Ensure pre-existing values do not affect the script
# Set to default value
unset ARG_HELP && ARG_HELP=""
unset ARG_DEBUG && ARG_DEBUG=""
unset REQUIRED_MISSING && REQUIRED_MISSING=0
unset ARGUMENT_MISSING && ARGUMENT_MISSING=0

# unset ARCHIVE_VERSION && ARCHIVE_VERSION=""
# unset ARCHIVE_URL && ARCHIVE_URL=""

function sendvalues() {
  local -r rtrval=$1
  local -r archive_version="${2-}"
  printf "$rtrval $archive_version \n"
  exit $1
}

function gittag() {
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
    GIT-REMOTE:      ${GIT_REPOSITORY}
    TMP_FILE:        ${TMP_FILE}
EOF
)
  log "${log_msg}"



  # set -x 
# echo "one two alpha beta" | sed "${IGNORE_PRERELEASES[@]}"
# printf "one\ntwo\nthree\nfour\nbeta\n" | sed ''"${IGNORE_PRERELEASES[*]}"''
# printf "one\ntwo\nthree\nfour\nbeta\n" | sed "/dev/d; /alpha/d; /beta/d; /rc/d;"
# set +x




  log "Execute task to get artefact version and URL"
  execute_tasks

  errval=$?

  [[ "${errval}" -gt 0 ]] && sendvalues 4

  sendvalues 0 "${ARCHIVE_VERSION}"

  exit 0
}


## -----------------------------------------------------------------------------
## Perform tasks to execute.
## -----------------------------------------------------------------------------
execute_tasks() {
# URL:             ${GH_API_URL}${GH_API_URI}
# Search Criteria: ${SEARCH_CRITERIA} 
# Search Tag:      ${SEARCH_TAG} 
# Scratch File:    ${TMP_FILE}

# https://gist.github.com/steinwaywhw/a4cd19cda655b8249d908261a62687f8

# git ls-remote --tags https://github.com/jgm/pandoc.git | sed -nE 's#.*refs/tags/(v?[0-9]+(\.[0-9]+)*)$#\1#p' | sort -Vr | head -n 1

# https://gist.github.com/steinwaywhw/a4cd19cda655b8249d908261a62687f8#gistcomment-2928051
# https://stackoverflow.com/questions/10649814/get-last-git-tag-from-a-remote-repo-without-cloning

  # Get list of tags from remote git, remove sha and refs/tags path and just list the tag

   git $(echo "${GIT_SEARCH_SUFFIX[@]/#/-c }")  ls-remote --sort='-v:refname' --tags --refs "${GIT_REPOSITORY}" ${SEARCH_CRITERIA} | sed -E 's/^[[:xdigit:]]+[[:space:]]+refs\/tags\/(.+)/\1/g' > ${TMP_FILE}

   if [ 0 -eq 0 ]; then
    readonly ARCHIVE_VERSION=$(grep -m 1 -v "${IGNORE_PRERELEASES}" ${TMP_FILE})
   else
     #TODO - Add option to be able to get latest tag even if it is a prerelease
    readonly ARCHIVE_VERSION=$(head --lines 1 ${TMP_FILE})
   fi

  return 0
}

show_usage() {
  printf "Usage: %s [OPTION...]\n" "${SCRIPT_NAME}" >&2
  printf "  -d, --debug\t\tLog messages while processing\n" >&2
  printf "  -h, --help\t\tShow this help message then exit\n" >&2
  printf "  -r, --repo\t\tGithub Repo to hit in the form of {owner}\{repository}\n" >&2
  printf "  -s, --search\t\tTag prefix to fiter on\n" >&2
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
       -r|--git-remote)
        readonly ARG_GIT_REPOSITORY="$2"
        consume=2
      ;;
      -s|--git-tag-filter)
        readonly ARG_SEARCH="$2"
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
  required git "https://git-scm.com/"
}

function required_arguments() {
  local missing=0


   if [ ! "${ARG_GIT_REPOSITORY:-}" ]; then
     warning '--git-remote must be provided'
     missing=$(( missing + 1 ))
   fi

  ARGUMENT_MISSING=$missing
}

function setup_for_work() {
   # readonly GH_API_URI="/repos/${ARG_REPO}/tags"
   readonly SEARCH_CRITERIA="${ARG_SEARCH-}"
   # readonly SEARCH_TAG="${ARG_TAG-latest}"

   readonly GIT_REPOSITORY="${ARG_GIT_REPOSITORY}"



   if [[ ! "${ARG_TMPDIR:-}" ]]; then
     readonly TMP_FILE=$(mktemp -t gittag.XXXXXXXXX)
     trap "rm -rf ${TMP_FILE}" EXIT ERR
   else
     readonly TMP_FILE=$(mktemp --tmpdir="${ARG_TMPDIR}" -t gittag.XXXXXXXXX)
   fi

}

if [ "${BASH_SOURCE[0]}" != "${0}" ]; then
    export -f gittag
  else
    gittag "${@}"
    exit $?
fi
