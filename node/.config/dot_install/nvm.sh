#! /bin/bash

if test "$BASH" = "" || "$BASH" -uc "a=();true \"\${a[@]}\"" 2>/dev/null; then
     # Bash 4.4, Zsh
     set -euo pipefail
 else
     # Bash 4.3 and older chokes on empty arrays with set -u
     set -eo pipefail
 fi
 shopt -s nullglob globstar

require(){ hash "$@" || exit 127; }

NVM_VERSION="v0.34.0"

[ $(which curl) ] || sudo apt-get install -y curl
require curl

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh | bash

nvm install --lts
