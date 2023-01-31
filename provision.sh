#!/bin/bash

# This script should be run as the target user. It uses sudo where appropriate.

# exit on error
set -Eeo pipefail

if [[ $(uname) == 'Darwin' ]]; then
    source provision/platforms/all.sh
    source provision/platforms/macos.sh
elif grep -q Ubuntu /etc/issue; then
    #source provision/sudoise.sh
    source provision/platforms/all.sh
    source provision/platforms/debian.sh
elif grep -q Debian /etc/issue; then
    #source provision/sudoise.sh
    source provision/platforms/all.sh
    source provision/platforms/debian.sh
elif grep -q Raspbian /etc/issue; then
    #source provision/sudoise.sh
    source provision/platforms/all.sh
    source provision/platforms/debian.sh
else
    echo "Unsupported Platform"
    exit 2
fi

echo
echo "Switch to zsh with: chsh -s \$(which zsh)"

# display the splash
if which figlet &>/dev/null; then
	figlet -f slant dotfiles
fi
echo "Provision Complete"
