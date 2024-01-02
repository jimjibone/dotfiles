source ~/.env.sh

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

source ~/.aliases
source ~/.functions.sh

SAVEHIST=$HISTSIZE
unsetopt EXTENDED_HISTORY # just a list of commands so bash_history is compatible
setopt INC_APPEND_HISTORY # immediate sharing of history
setopt histignorealldups # removal of duplicate command history in memory -- see cleanup-history for history file de-dup
# pass * if globbing fails (etc)
unsetopt NOMATCH
# auto rehash to discover execs in path
setopt nohashdirs
# with arrow keys
zstyle ':completion:*' menu select
setopt completealiases
setopt PROMPT_SUBST
autoload -U colors && colors

# zsh will use vi bindings if you have vim as the editor. I want emacs.
# zsh does not use gnu readline, but zle
bindkey -e

# Completion
autoload -U compinit && compinit
# source ~/.zsh/woodhouse-zsh-completions.sh
compdef d=git

# zsh-git-prompt
# https://github.com/olivierverdier/zsh-git-prompt
ZSH_THEME_GIT_PROMPT_CACHE=1
source ~/.zsh/zsh-git-prompt/zshrc.sh

# syntax highlighting
# https://github.com/zsh-users/zsh-syntax-highlighting
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# history search by substring - must be loaded after syntax highlighting
# https://github.com/zsh-users/zsh-history-substring-search
source ~/.zsh/zsh-history-substring-search/zsh-history-substring-search.zsh

# fast/unobtrusive autosuggestions for zsh.
# https://github.com/zsh-users/zsh-autosuggestions
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# case insensitive completion
# http://stackoverflow.com/questions/24226685/have-zsh-return-case-insensitive-auto-complete-matches-but-prefer-exact-matches
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

PROMPT="\$(__exit_warn)
%F{36}\$CMD_TIMER_PROMPT%f%F{${PROMPT_COLOUR}}%n@%m:\$PWD%f%F{243}\$(__git_prompt)\$(__p4_prompt)\$(__conda_prompt)%f
$ "

# if you call a different shell, this does not happen automatically. WTF?
export SHELL=$(which zsh)

# before prompt (which is after command)
function precmd() {
	# reload history to get immediate update because my computer is fast, yo.
	fc -R

    # reset the terminal, in case something (such as cat-ing a binary file or
    # failed SSH) sets a strange mode
    stty sane
    _cmd_timer_end
}

# just before cmd is executed
function preexec() {
    # should be first, others may change env
    # _tmux_update_env
    # _update_agents
    _cmd_timer_start
}

# sudo-ize command
bindkey -s '\C-s' "\C-asudo \C-e"

# bind UP and DOWN arrow keys
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down
# https://github.com/zsh-users/zsh-history-substring-search
# both methods are necessary
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

_disable_flow_control

~/.bin/cleanup-history.py ~/.history
fc -R # reload history

# _tmux_window_name_read

# source any local configuration
[ -e ~/.zshrc-local ] && source ~/.zshrc-local

# if [ $(uname) == 'Darwin' ]; then
#     eval `keychain --quiet --eval --agents ssh --inherit any id_rsa`
# elif grep -q -E 'Ubuntu|Raspbian' /etc/issue; then
#     eval `keychain --quiet --eval --agents ssh id_rsa`
# fi

trap "~/.bin/cleanup-history.py ~/.history" EXIT
