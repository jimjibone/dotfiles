#!/bin/bash
set -e
cd $(dirname $0)

# https://stackoverflow.com/a/5947802/1850206
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
GREY='\033[0;90m'
NC='\033[0m' # No Color

# This script should be run as the target user. It uses sudo where appropriate.
if [ $(id -u) -eq 0 ]; then
	echo -e "${RED}please run this script as the target user!${NC}"
	exit 1
fi

# exit on error
set -Eeo pipefail

# display the splash
if which figlet &>/dev/null; then
	figlet -f slant dotfiles
fi
echo -e ${BLUE}"provisioning system...${NC}"

# https://stackoverflow.com/questions/29436275/how-to-prompt-for-yes-or-no-in-bash
# usage: yes_or_no "$message" && do_something
function yes_or_no {
	while true; do
		echo -en ${BLUE}
		read -p "$* [y/n]: " yn
		echo -en ${NC}
		case $yn in
			[Yy]*) return 0 ;;
			[Nn]*) return 1 ;;
		esac
	done
}

if [[ $(uname) == 'Darwin' ]]; then
	echo -e "${BLUE}platform:${NC} macos"

	PACKAGES=""
	if yes_or_no "install figlet?"; then
		PACKAGES="$PACKAGES figlet"
	fi
	if yes_or_no "install starship?"; then
		PACKAGES="$PACKAGES starship"
	fi

	if [ ! -z "$PACKAGES" ]; then
		(echo -en ${GREY}; set -x; brew install $PACKAGES); echo -en ${NC}
	fi

# elif grep -q Ubuntu /etc/issue; then
# elif grep -q Debian /etc/issue; then
# elif grep -q Raspbian /etc/issue; then
else
	echo -e "${RED}unsupported platform!${NC}"
	exit 2
fi

# all done
echo -e "${GREEN}provision complete!${NC}"
