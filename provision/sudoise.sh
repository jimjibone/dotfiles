#!/bin/bash

if [ "$SUDOISED" = true ] ; then
    echo "Already sudoised"
    return
else
    SUDOISED=true
fi

# authorise sudo early on
if ! sudo -n echo 2>/dev/null; then
    echo "Please enter sudo password. Sudo session will be kept alive until this script exits."
    # sudo -v is technically correct but asks for a non-existent password on fresh AWS Ubuntu AMIs
    sudo echo -n
fi

# sudo keepalive. This will keep the sudo watchdog fed until this script exits.
# This works buy poking the parent process to see if it's still alive.
while true; do sudo -n true; sleep 15; kill -0 "$$" || exit; done 2>/dev/null &
