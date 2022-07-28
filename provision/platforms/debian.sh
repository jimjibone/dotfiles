#!/bin/bash
sudo apt-get -y update
sudo apt-get -y install git vim zsh mosh tmux figlet keychain
sudo cp provision/config/sshd_config /etc/ssh/sshd_config
