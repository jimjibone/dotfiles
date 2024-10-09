#!/bin/bash
set -e
cd $(dirname $0)

# https://stackoverflow.com/a/5947802/1850206
GREEN='\033[0;32m'
RED='\033[0;31m'
GREY='\033[0;90m'
NC='\033[0m' # No Color

# display the splash
if which figlet &>/dev/null; then
	figlet -f slant dotfiles
else
	echo -e ${GREY}"installing dotfiles...${NC}"
fi

# destroy old dirs
# test -d ~/.vim/ && rm -rf ~/.vim/
# test -d ~/.zsh/ && rm -rf ~/.zsh/

# setup ssh dir and files
echo -e "${GREEN}setting up .ssh directory and files${NC}"
if [ ! -d ~/.ssh ]; then
	mkdir ~/.ssh
	chmod 700 ~/.ssh
fi
touch ~/.ssh/known_hosts
touch ~/.ssh/authorized_keys
chmod 644 ~/.ssh/authorized_keys
chmod 644 ~/.ssh/known_hosts
test -f ~/.ssh/config && chmod 644 ~/.ssh/config
test -f ~/.ssh/id_rsa && chmod 600 ~/.ssh/id_rsa
test -f ~/.ssh/id_rsa.pub && chmod 644 ~/.ssh/id_rsa.pub

# copy dotfiles separately, normal glob does not match
echo -e "${GREEN}copying dotfiles${NC}"
#cp -r home/.??* ~ 2> /dev/null
cp .p10k.zsh ~/
cp .tmux.conf ~/
cp .wezterm.lua ~/
cp .zshrc ~/
mkdir -p ~/.config/systemd/user
cp .config/systemd/user/* ~/.config/systemd/user/

# refresh systemd
echo -e "${GREEN}refreshing systemd${NC}"
systemctl --user daemon-reload
systemctl --user enable --now xbanish.service

# install vim plugins - archived, now using nvim
# echo -e "${GREEN}Installing vim plugins${NC}"
# vim -c 'PlugInstall' -c 'qa'

# all done
echo -e "${GREEN}install complete!${NC}"

# print recommendations
# echo "Add ssh key to your keychain with: ssh-add -K ~/.ssh/id_rsa"
if [[ $SHELL != *zsh* ]]; then
	echo -e "${RED}Switch to zsh!${NC} chsh -s \$(which zsh)"
fi
