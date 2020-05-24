#! /usr/bin/env bash

# abort on nonzero exitstatus
set -o errexit
# abort on unbound variable
set -o nounset
# dont hide errors within pipes
set -o pipefail


## ANSI colour escape sequences
readonly COLOUR_BLUE='\033[1;34m'
readonly COLOUR_PINK='\033[1;35m'
readonly COLOUR_DKGRAY='\033[30m'
readonly COLOUR_DKRED='\033[31m'
readonly COLOUR_YELLOW='\033[1;33m'
readonly COLOUR_OFF='\033[0m'

## Colour definitions used by script
readonly COLOUR_LOGGING=${COLOUR_BLUE}
readonly COLOUR_WARNING=${COLOUR_YELLOW}
readonly COLOUR_ERROR=${COLOUR_DKRED}

# -----------------------------------------------------------------------------
# Check for a required command.
#
# $1 - Command to execute.
# $2 - Where to find the command's source code or binaries.
# -----------------------------------------------------------------------------

required() {
  local missing=0

 if ! command -v "$1" > /dev/null 2>&1; then
   warning "Missing requirement: install -->> [ $1 ] ($2)"
   missing=1
 fi

  REQUIRED_MISSING=$(( REQUIRED_MISSING + missing ))
}

# -----------------------------------------------------------------------------
# Write coloured text to standard output.
#
# $1 - The text to write
# $2 - The colour to write in
# -----------------------------------------------------------------------------
function coloured_text() {
  printf "%b%s%b\n" "$2" "$1" "${COLOUR_OFF}" >&2
}

# -----------------------------------------------------------------------------
# Write a warning message to standard output.
#
# $1 - The text to write
# -----------------------------------------------------------------------------
function warning() {
  coloured_text "$1" "${COLOUR_WARNING}"
}

# -----------------------------------------------------------------------------
# Write an error message to standard output.
#
# $1 - The text to write
# -----------------------------------------------------------------------------
function error() {
  coloured_text "$1" "${COLOUR_ERROR}"
}
# -----------------------------------------------------------------------------
# Write a timestamp and message to standard output.
#
# $1 - The text to write
# -----------------------------------------------------------------------------
function info() {
  coloured_text "$1" "${COLOUR_LOGGING}"
}

# -----------------------------------------------------------------------------
# Write a timestamp and message to standard output.
#
# $1 - The text to write
# -----------------------------------------------------------------------------
function log() {
  if [ -n "${ARG_DEBUG}" ]; then
    printf "[%s] " "$(date +%H:%I:%S.%4N)" >&2
    coloured_text "$1" "${COLOUR_LOGGING}"
  fi
}
