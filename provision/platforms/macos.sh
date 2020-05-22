#!/bin/bash

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
packages=(visual-studio-code 1password contexts iterm2 firefox vlc)
for package in "${packages[@]}"; do
    brew cask upgrade $package || brew cask install $package
done

# upgrade or install cli things (logic necessary)
echo "Installing/upgrading brew packages"
packages=(mosh figlet keychain golang protobuf nodejs ffmpeg schollz/tap/croc tmux)
for package in "${packages[@]}"; do
    brew upgrade $package || brew install $package
done
