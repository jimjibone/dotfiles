#!/bin/bash
sudo apt-get -y update
sudo apt-get -y install git vim zsh mosh tmux figlet keychain docker.io curl ssh vim ninja-build cmake
sudo cp ../config/sshd_config /etc/ssh/sshd_config
