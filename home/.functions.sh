# really simple git prompt, just showing branch which is all I want. Replaced
# zsh-git-prompt as that displayed the wrong branch is some cases. I didn't
# need the other features.
function __git_prompt {
    local branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || true)

    if [ "$branch" ]; then
        echo -n " ($branch)"
    fi
}

function __p4_prompt {
	if [ "$P4CLIENT" ]; then
        echo -n " ($P4CLIENT)"
    fi
}

function __exit_warn {
	# test status of last command without affecting it
	st=$?
	test $st -ne 0 \
		&& printf "\n\33[31mExited with status %s\33[m" $st
}

# get new or steal existing tmux
function tm {
	# must not already be inside tmux
	test ! "$TMUX" || return
	# detach any other clients
	# attach or make new if there isn't one
	tmux attach -d || tmux
}

function _disable_flow_control {
    # Ctrl+S can freeze the terminal, requiring
    # Ctrl+Q to restore. It can result in an apparent hung terminal, if
    # accidentally pressed.
    stty -ixon -ixoff
    # https://superuser.com/questions/385175/how-to-reclaim-s-in-zsh
    stty stop undef
    stty start undef
}

# this is a simple wrapper for scp to prevent local copying when a colon is forgotten
# It's annoying to create files named naggie@10.0.0.1
# use ~/.aliases to enable.
function scp {
    if [ $1 ] && ! echo "$@" | grep -q ':' &> /dev/null; then
        echo "No remote host specified. You forgot ':'"
        return 1
    fi

    command scp "$@"
}

# cd then ls
function cd {
	builtin cd "$@" && ls
}

function _cmd_timer_start {
    CMD_TIMER_START=$(date +%s)
}

# must be in precmd not prompt (which creates a subshell)
# stops/resets timer and sets CMD_TIMER_PROMPT
function _cmd_timer_end  {
    unset CMD_TIMER_PROMPT
    test -z $CMD_TIMER_START && return
    CMD_TIMER_STOP=$(date +%s)
    DURATION=$(($CMD_TIMER_STOP - $CMD_TIMER_START))
    (( $DURATION < 60 )) && return

    CMD_TIMER_PROMPT="Duration: $(~/.bin/human-time.py $CMD_TIMER_START)
"

    # precmd is not run if there is no cmd, so don't keep the timer running
    # note unset does not work due to scope
    unset CMD_TIMER_START
}
