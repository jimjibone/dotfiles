#!/bin/bash

# macos -- get homebrew
if [ which figlet &>/dev/null ]; then
    echo "Installing homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "Updating homebrew"
    brew update
fi

# upgrade or install gui apps (logic necessary)
# echo "Installing/upgrading brew casks"
# packages=(visual-studio-code 1password contexts iterm2 firefox vlc)
# for package in "${packages[@]}"; do
#     brew cask upgrade $package || brew cask install $package
# done

# upgrade or install cli things (logic necessary)
echo "Installing/upgrading brew packages"
packages=(mosh figlet keychain golang protobuf nodejs tmux)
for package in "${packages[@]}"; do
    brew upgrade $package || brew install $package
done
