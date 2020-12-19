#!/bin/bash
set -e
cd $(dirname $0)

# destroy old dirs
# test -d ~/.vim/ && rm -rf ~/.vim/
# test -d ~/.zsh/ && rm -rf ~/.zsh/

# setup ssh dir and files
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

# echo "Add ssh key to your keychain with: ssh-add -K ~/.ssh/id_rsa"
# echo "Switch to zsh with: chsh -s \$(which zsh)"

# copy dotfiles separately, normal glob does not match
cp -r home/.??* ~ 2> /dev/null
# cp -a bin ~

# display the splash
if which figlet &>/dev/null; then
	figlet -f slant dotfiles
fi
echo Install Complete
