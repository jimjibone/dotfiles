dotfiles
========

Painfully crafted configuration.


Install
-------

1. Clone it -- one of:
    - `git clone https://github.com/jimjibone/dotfiles.git ~/dotfiles`
    - `git clone git@github.com:jimjibone/dotfiles.git ~/dotfiles`
2. Provision your machine: `~/dotfiles/provision.sh` (installs missing tools and upgrades)
3. Install it: `~/dotfiles/install.sh`
4. Switch your main shell to zsh: `chsh -s $(which zsh)`
5. Switch to zsh now: `zsh`
6. Or, source it: `source ~/.zshrc`


Fresh Install
-------------

## Debian (Buster)

1. Generate keys: `ssh-keygen -t ed25519 -C "$(whoami)@$(hostname -s)"`
2. Get git: `sudo apt update && sudo apt install git`
3. Complete the install guide above


Misc
----

1. Disable caps lock on Ubuntu: https://askubuntu.com/questions/351388/how-to-disable-the-caplock
2. Hide the mouse while typing:

    ````sh
    sudo apt update && sudo apt install xbanish
    cp ./home/.config/systemd/user/xbanish.service ~/.config/systemd/user/xbanish.service
    systemctl --user daemon-reload
    systemctl --user enable --now xbanish.service
    ````
