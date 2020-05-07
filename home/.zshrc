# pass * if globbing fails (etc)
unsetopt NOMATCH

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

export GOPATH=~/go
export PATH=$GOPATH/bin:$PATH
export GOPRIVATE=github.com/jimjibone/*

HISTSIZE=9000
SAVEHIST=9000
# Change default as unconfigured bash could clobber history. Bash can run
# unconfigured if CTRL+C is hit during initialisation.
HISTFILE=~/.history
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
unsetopt EXTENDED_HISTORY # just commands plskthx so bash_history is compatible
#setopt INC_APPEND_HISTORY # immediate sharing of history

# The ls alias
if [[ "$(uname)" == 'Darwin' ]]; then
    export CLICOLOR=1
    export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx
else
    alias ls='ls --color=auto' # does not work on macos
fi

# Aliases
alias s='git status'
alias d='git diff'
alias la='ls -al'

# cd then ls
function cd {
	builtin cd "$@" && ls
}

# Prompt functions.
function __exit_warn {
    # test status of last command without affecting it
    stat=$?
    test $stat -ne 0 && printf "\n\33[31mExited with status %s\33[m" $stat
}
setopt PROMPT_SUBST
autoload -U colors && colors

# zsh-git-prompt
ZSH_THEME_GIT_PROMPT_CACHE=1
source ~/.zsh/zsh-git-prompt/zshrc.sh

# Sometimes not set or fully qualified; simple name preferred.
export HOSTNAME=$(hostname -s)

# Set colour from hostname
export SYSTEM_COLOUR=$(~/bin/system-colour.py $HOSTNAME)
[ $TMUX ] && tmux set -g status-left-bg colour${SYSTEM_COLOUR} &>/dev/null

# If user is root, use red to indicate danger.
if [ $USER == root ]; then
    PROMPT_COLOUR=160 # red
else
    PROMPT_COLOUR=$SYSTEM_COLOUR
fi

# Define the prompt
PROMPT="\$(__exit_warn)
%F{${PROMPT_COLOUR}}%n@%M:\$PWD%f \$(git_super_status)%F{239} \$(date +%T)%f
$ "

# sudo-ize command
bindkey -s '\C-s' "\C-asudo \C-e"

if [ $(uname) == 'Darwin' ]; then
    # syntax highlighting
    # https://github.com/zsh-users/zsh-syntax-highlighting
    source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    # history search by substring - must be loaded after syntax highlighting
    # https://github.com/zsh-users/zsh-history-substring-search
    source /usr/local/share/zsh-history-substring-search/zsh-history-substring-search.zsh
    
    # bind UP and DOWN arrow keys
    bindkey "$terminfo[kcuu1]" history-substring-search-up
    bindkey "$terminfo[kcud1]" history-substring-search-down
    # both methods are necessary
    bindkey '^[[A' history-substring-search-up
    bindkey '^[[B' history-substring-search-down

    # case insensitive completion
    # http://stackoverflow.com/questions/24226685/have-zsh-return-case-insensitive-auto-complete-matches-but-prefer-exact-matches
    zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
fi
