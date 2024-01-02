#!/bin/bash
set -e
cd $(dirname $0)

# https://stackoverflow.com/a/5947802/1850206
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# destroy old dirs
# test -d ~/.vim/ && rm -rf ~/.vim/
# test -d ~/.zsh/ && rm -rf ~/.zsh/

# setup ssh dir and files
echo -e "${GREEN}Setting up .ssh directory and files${NC}"
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
echo -e "${GREEN}Copying dotfiles${NC}"
cp -r home/.??* ~ 2> /dev/null
# cp -a bin ~

# install vim plugins - archived, now using nvim
# echo -e "${GREEN}Installing vim plugins${NC}"
# vim -c 'PlugInstall' -c 'qa'

# init conda if installed
if which conda &>/dev/null; then
    echo -e "${GREEN}Initialising conda${NC}"
    conda init $(basename $SHELL) &>/dev/null
fi

# add kitty desktop integration
# see: https://sw.kovidgoyal.net/kitty/binary/
if [ -e ~/.local/kitty.app ]; then
    mkdir -p ~/.local/bin/
    if [ ! -e ~/.local/bin/kitty ]; then
        echo -e "${GREEN}Setting up kitty shortcuts${NC}"
        ln -s ~/.local/kitty.app/bin/kitty ~/.local/bin/
        cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
        cp ~/.local/kitty.app/share/applications/kitty-open.desktop ~/.local/share/applications/
        sed -i "s|Icon=kitty|Icon=/home/$USER/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty*.desktop
        sed -i "s|Exec=kitty|Exec=/home/$USER/.local/kitty.app/bin/kitty|g" ~/.local/share/applications/kitty*.desktop
    fi

    # setup terminfo for kitty
    if [ ! -d ~/.terminfo ]; then
        echo -e "${GREEN}Setting up terminfo for kitty${NC}"
        mkdir -p ~/.terminfo/{78,x}
        ln -snf ../x/xterm-kitty ~/.terminfo/78/xterm-kitty
        tic -x -o ~/.terminfo "$KITTY_INSTALLATION_DIR/terminfo/kitty.terminfo"
    fi
fi

# display the splash
if which figlet &>/dev/null; then
    figlet -f slant dotfiles
fi
echo -e "${GREEN}Install complete!${NC}"

# print recommendations
# echo "Add ssh key to your keychain with: ssh-add -K ~/.ssh/id_rsa"
if [[ $SHELL != *zsh* ]]; then
    echo -e "${RED}Switch to zsh!${NC} chsh -s \$(which zsh)"
fi
