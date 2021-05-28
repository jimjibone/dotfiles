# common static env here
export HOME=~
export GOPATH=$HOME/go
export PATH=$HOME/.bin:$GOPATH/bin:$PATH
export GOPRIVATE=github.com/jimjibone/*
# export EDITOR=vim-wrapper
export EDITOR=vim
export PAGER="less -R"
export LANG=en_GB.UTF-8
export GCC_COLORS=1

# Sometimes not set or fully qualified; simple name preferred.
export HOSTNAME=$(hostname -s)
export SYSTEM_COLOUR=$($HOME/.bin/system-colour.py $HOSTNAME)

if [[ $USER == root ]]; then
    PROMPT_COLOUR=160 # red
else
    PROMPT_COLOUR=$SYSTEM_COLOUR
fi

HISTSIZE=5000

# Change default as unconfigured bash could clobber history. Bash can run
# unconfigured if CTRL+C is hit during initialisation.
HISTFILE=~/.history
