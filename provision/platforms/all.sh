#!/bin/bash

# zsh-syntax-highlighting
if [ ! -d ~/.zsh/zsh-syntax-highlighting ]; then
    echo "Cloning zsh-syntax-highlighting"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting
else
    echo "Updating zsh-syntax-highlighting"
    pushd ~/.zsh/zsh-syntax-highlighting
    git pull
    popd
fi

# zsh-history-substring-search
if [ ! -d ~/.zsh/zsh-history-substring-search ]; then
    echo "Cloning zsh-history-substring-search"
    git clone https://github.com/zsh-users/zsh-history-substring-search.git ~/.zsh/zsh-history-substring-search
else
    echo "Updating zsh-history-substring-search"
    pushd ~/.zsh/zsh-history-substring-search
    git pull
    popd
fi

# zsh-git-prompt
if [ ! -d ~/.zsh/zsh-git-prompt ]; then
    echo "Cloning zsh-git-prompt"
    git clone https://github.com/olivierverdier/zsh-git-prompt.git ~/.zsh/zsh-git-prompt
else
    echo "Updating zsh-git-prompt"
    pushd ~/.zsh/zsh-git-prompt
    git pull
    popd
fi
