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
	figlet -f slant dotfiles v2
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
	if yes_or_no "install figlet (fancy text)?"; then
		PACKAGES="$PACKAGES figlet"
	fi
	if yes_or_no "install starship (improved prompt)?"; then
		PACKAGES="$PACKAGES starship"
	fi
	if yes_or_no "install eza (ls replacement)?"; then
		PACKAGES="$PACKAGES eza"
	fi

	if [ ! -z "$PACKAGES" ]; then
		(
			echo -en ${GREY}
			set -x
			brew install $PACKAGES
		)
		echo -en ${NC}
	fi

elif grep -q Fedora /etc/os-release; then
	echo -e "${BLUE}platform:${NC} fedora"

	PACKAGES=""
	DO_STARSHIP=0
	if yes_or_no "install figlet (fancy text)?"; then
		PACKAGES="$PACKAGES figlet"
	fi
	if yes_or_no "install starship (improved prompt)?"; then
		DO_STARSHIP=1
	fi
	if yes_or_no "install zsh (better shell)?"; then
		PACKAGES="$PACKAGES zsh"
	fi
	if yes_or_no "install eza (ls replacement)?"; then
		PACKAGES="$PACKAGES eza"
	fi
	if yes_or_no "install fzf (fuzzy search)?"; then
		PACKAGES="$PACKAGES fzf"
	fi
	if yes_or_no "install zoxide (better cd)?"; then
		PACKAGES="$PACKAGES zoxide"
	fi

	if [ ! -z "$PACKAGES" ]; then
		(
			echo -en ${GREY}
			set -x
			sudo dnf install $PACKAGES
		)
		echo -en ${NC}
	fi
	if [ $DO_STARSHIP -eq 1 ]; then
		curl -sS https://starship.rs/install.sh | sh
	fi

elif grep -q Debian /etc/issue; then
	echo -e "${BLUE}platform:${NC} debian"

	PACKAGES=""
	DO_STARSHIP=0
	if yes_or_no "install figlet (fancy text)?"; then
		PACKAGES="$PACKAGES figlet"
	fi
	if yes_or_no "install starship (improved prompt)?"; then
		DO_STARSHIP=1
	fi
	if yes_or_no "install zsh (better shell)?"; then
		PACKAGES="$PACKAGES zsh"
	fi
	if yes_or_no "install eza (ls replacement)?"; then
		if ! apt list --installed 2>/dev/null | grep -q "^eza/"; then
			sudo mkdir -p /etc/apt/keyrings
			wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
			echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
			sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
		fi
		PACKAGES="$PACKAGES eza"
	fi
	if yes_or_no "install fzf (fuzzy search)?"; then
		PACKAGES="$PACKAGES fzf"
	fi
	if yes_or_no "install zoxide (better cd)?"; then
		PACKAGES="$PACKAGES zoxide"
	fi

	if [ ! -z "$PACKAGES" ]; then
		(
			echo -en ${GREY}
			set -x
			sudo apt-get update && sudo apt-get install -y $PACKAGES
		)
		echo -en ${NC}
	fi
	if [ $DO_STARSHIP -eq 1 ]; then
		curl -sS https://starship.rs/install.sh | sh
	fi
else
	echo -e "${RED}unsupported platform!${NC}"
	exit 2
fi

# all done
echo -e "${GREEN}provision complete!${NC}"
