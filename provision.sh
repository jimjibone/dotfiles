#!/bin/bash
set -e
cd $(dirname $0)

cat <<EOF
This script is intended to be run once. It will install packages then sync dotfiles.
Hit CTRL+C to abort in the next 3 seconds....
EOF

sleep 3

PLATFORM=$(uname)

if [ $(uname) == 'Darwin' ]; then
    # macos -- get homebrew
    if [ ! -f /usr/local/bin/brew ]; then
        echo "Installing homebrew"
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    else
        echo "Updating homebrew"
        brew update
    fi

    # upgrade or install gui apps (logic necessary)
    echo "Installing/upgrading brew casks"
    packages=(visual-studio-code 1password contexts iterm2)
    for package in "${packages[@]}"; do
        brew cask upgrade $package || brew cask install $package
    done

    # upgrade or install cli things (logic necessary)
    echo "Installing/upgrading brew packages"
    packages=(golang mosh protobuf nodejs zsh-syntax-highlighting zsh-history-substring-search schollz/tap/croc)
    for package in "${packages[@]}"; do
        brew upgrade $package || brew install $package
    done

    # get zsh-git-prompt (with git)
    if [ ! -d ~/.zsh/zsh-git-prompt ]; then
        echo "Cloning zsh-git-prompt"
        git clone git@github.com:olivierverdier/zsh-git-prompt.git ~/.zsh/zsh-git-prompt
    else
        echo "Updating zsh-git-prompt"
        pushd ~/.zsh/zsh-git-prompt
        git pull
        popd
    fi

    # get vscode extensions
    # list installed extensions with: `code --list-extensions`
    echo "Installing vscode extensions"
    extensions=(ms-python.python ms-vscode.Go zxh404.vscode-proto3 ms-vscode-remote.remote-ssh)
    for extension in "${extensions[@]}"; do
        code --install-extension $extension
    done
else
    echo "Unsupported OS"
    exit 2
fi
