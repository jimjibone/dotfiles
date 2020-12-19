#!/bin/bash
set -e

# copy vscode settings
echo "Installing vscode settings"
# Windows %APPDATA%\Code\User\settings.json
# macOS $HOME/Library/Application Support/Code/User/settings.json
# Linux $HOME/.config/Code/User/settings.json
if [ -d "$HOME/Library/Application Support/Code/User/" ]; then
    # macos
    cp settings.json "$HOME/Library/Application Support/Code/User/settings.json"
elif [ -d "$HOME/.config/Code/User/" ]; then
    # linux
    cp settings.json "$HOME/.config/Code/User/settings.json"
else
    echo "ERROR: settings not installed"
    exit 1
fi

# get vscode extensions
# list installed extensions with: `code --list-extensions`
echo "Installing vscode extensions"
while IFS= read -r line; do
    code --install-extension $line
done < extensions.txt
