if [[ -f "/opt/homebrew/bin/brew" ]] then
	# If you're using macOS, you'll want this enabled
	eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
	mkdir -p "$(dirname $ZINIT_HOME)"
	git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-history-substring-search
zinit light Aloxaf/fzf-tab

# Add in snippets
#zinit snippet OMZP::git
#zinit snippet OMZP::sudo
#zinit snippet OMZP::archlinux
#zinit snippet OMZP::aws
#zinit snippet OMZP::kubectl
#zinit snippet OMZP::kubectx
#zinit snippet OMZP::command-not-found

# Load completions
autoload -Uz compinit && compinit

# Load history substring search
# zinit ice wait atload'_history_substring_search_config'
#source "${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/plugins/zsh-users---zsh-history-substring-search/zsh-history-substring-search.zsh"

zinit cdreplay -q

# Keybindings
# substring search is superior
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
# fix special keys
bindkey "^[[H"  beginning-of-line # fix home going to start of line
bindkey "^[[F"  end-of-line # fix end gonig to end of line
bindkey "^[[3~" delete-char # fix delete key doing delete

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Aliases
alias ls='ls --color'
alias vim='nvim'
alias c='clear'
alias la='ls -alh --color'
alias gf='git fetch'
alias s='git status'
alias gc='git commit'
alias gsu='git submodule update --init --recursive'
alias gl='git log --oneline --all --graph --decorate --pretty=format:"%C(yellow)%h %ar%C(auto)%d%C(reset) %s %C(blue)%cn"'
alias lg='lazygit'

# Alias functions
# get new or steal existing tmux
function tm {
	# must not already be inside tmux
	test ! "$TMUX" || return
	# detach any other clients
	# attach or make new if there isn't one
	tmux attach -d || tmux
}

# Source fzf git installations
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Common static env
export HOSTNAME=$(hostname -s) # Sometimes not set or fully qualified; simple name preferred.
export HOME=~
export GOPATH=$HOME/go
export PATH=$HOME/.bin:$HOME/.local/bin:$GOPATH/bin:$PATH
export GOPRIVATE=github.com/jimjibone
export EDITOR=nvim

# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"

# Custom cd (utilising zoxide)
function cd() {
	__zoxide_z "$@" && pwd && eza
}
alias ls='eza'
alias la='eza -aaglh'

# Allow git to auto-correct typos
git config --global help.autocorrect 10

# Source any local configuration
[ -e ~/.zshrc-local ] && source ~/.zshrc-local

# Enable starship
eval "$(starship init zsh)"
