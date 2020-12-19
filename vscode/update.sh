#!/bin/bash
set -e

# copy vscode settings
echo "Getting vscode settings"
# Windows %APPDATA%\Code\User\settings.json
# macOS $HOME/Library/Application Support/Code/User/settings.json
# Linux $HOME/.config/Code/User/settings.json
if [ -d "~/Library/Application Support/Code/User/" ]; then
    # macos
    cp "~/Library/Application Support/Code/User/settings.json" settings.json
fi

# get installed extensions
echo "Getting vscode extensions"
code --list-extensions > extensions.txt
