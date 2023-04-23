export PATH=/opt/homebrew/bin:$PATH

local READLINE_PATH=$(brew --prefix readline)
local OPENSSL_PATH=$(brew --prefix openssl)

# export LDFLAGS="-L$READLINE_PATH/lib -L$OPENSSL_PATH/lib -L/usr/local/opt/libffi/lib"
# export CPPFLAGS="-I$READLINE_PATH/include -I$OPENSSL_PATH/include -I/usr/local/opt/libffi/include"
# export PKG_CONFIG_PATH="$READLINE_PATH/lib/pkgconfig:$OPENSSL_PATH/lib/pkgconfig"
# export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$OPENSSL_PATH"

export LDFLAGS="-L/usr/local/opt/ruby@3.0/lib"
export CPPFLAGS="-I/usr/local/opt/ruby@3.0/include"
export PKG_CONFIG_PATH="/usr/local/opt/ruby@3.0/lib/pkgconfig"

export DOTFILES="$HOME/.dotfiles"
export PATH="$OPENSSL_PATH/bin:/usr/local/bin:/usr/local/sbin:$PATH"
export CACHE_DIR="$HOME/.cache"

[[ ! -d "$CACHE_DIR" ]] && mkdir -p "$CACHE_DIR"

# history settings
export HISTSIZE=100000
export SAVEHIST=100000
export HISTFILESIZE=$HISTSIZE
export HISTCONTROL=ignoredups
export HISTFILE="$CACHE_DIR/.zsh_history"
export HISTIGNORE="ls:cd:cd -:pwd:exit:date:* --help"

alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'

alias lsa='ls -lah'
alias ll='ls -lh'

# set fasd cache dir
export _FASD_DATA="$CACHE_DIR/.fasd" # set fasd data file location
export ZPLUG_HOME="$HOME/.zplug"
export NODE_REPL_HISTORY_FILE="$HOME/.node_history"

export MANPAGER='less -X'        # Don't clear the screen after quitting a manual page.
export LESS_TERMCAP_md="$yellow" # Highlight section titles in manual pages.

# Always enable colored `grep` output.
export GREP_OPTIONS='--color=auto'
export JOBS=max # tell npm to install concurrently
export EDITOR=vim
export VISUAL=vim

export SSH_KEY_PATH="$HOME/.ssh"
export AWS_CONFIG_FILE="$HOME/.aws/config"
export AWS_DEFAULT_PROFILE="default"
export ANDROID_HOME=/usr/local/opt/android-sdk

export GPG_TTY=$(tty)

# set the correct term with TMUX
if [[ -n "$TMUX" ]]; then
	export TERM=screen-256color
else
	export TERM=xterm-256color
fi

# language settings
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

setopt append_history
setopt bang_hist # !keyword
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_all_dups
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_reduce_blanks # trim blanks
setopt hist_verify
setopt inc_append_history
setopt share_history

setopt auto_cd           # if command is a path, cd into it
setopt auto_remove_slash # self explicit
setopt chase_links       # resolve symlinks
setopt correct           # try to correct spelling of commands
setopt extended_glob     # activate complex pattern globbing
setopt glob_dots         # include dotfiles in globbing
setopt print_exit_value  # print return value if non-zero
setopt no_beep           # Disable sound
unsetopt beep            # no bell on error
unsetopt bg_nice         # no lower prio for background jobs
unsetopt clobber         # must use >| to truncate existing files
unsetopt hist_beep       # no bell on error in history
unsetopt hup             # no hup signal at shell exit
unsetopt ignore_eof      # do not exit on end-of-file
unsetopt list_beep       # no bell on ambiguous completion
unsetopt rm_star_silent  # ask for confirmation for `rm *' or `rm path/*'

unsetopt menu_complete
unsetopt flowcontrol

setopt always_to_end    # when completing from the middle of a word, move the cursor to the end of the word
setopt complete_in_word # allow completion from within a word/phrase
setopt auto_menu
setopt list_ambiguous # complete as much of a completion until it gets ambiguous.

setopt auto_pushd
setopt pushd_ignore_dups
setopt pushdminus

zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'

zstyle ':completion:*' list-colors ''
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'

zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories

zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path $ZSH_CACHE_DIR

bindkey -e "use emacs key bindings"
bindkey '^a' beginning-of-line
bindkey '^e' end-of-line
bindkey '^r' history-incremental-search-backward

# shift-tab : go backward in menu (invert of tab)
bindkey '^[[Z' reverse-menu-complete

zstyle ':zplug:tag' depth 42

if [[ ! -d "$ZPLUG_HOME" ]]; then
	echo "Installing zplug"
	curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
	# zplug.sh domain has expired
	# curl -sL --proto-redir -all,https https://zplug.sh/installer | zsh
	source "$ZPLUG_HOME/init.zsh"
	zplug update
else
	source "$ZPLUG_HOME/init.zsh"
fi

fpath=("$DOTFILES/zsh/completions" $fpath)

zplug "zplug/zplug", hook-build:"zplug --self-manage"

zplug "creationix/nvm", use:nvm.sh
zplug "tj/git-extras", use:"etc/git-extras-completion.zsh", defer:3, if:"[[ $(command -v git) ]]"
zplug "tmuxinator/tmuxinator", use:"completion/tmuxinator.zsh", defer:3, if:"[[ $(command -v tmuxinator) ]]"

zplug "zsh-users/zsh-history-substring-search"
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "djui/alias-tips"
zplug "paulirish/git-open", as:plugin, if:"[[ $(command -v git) ]]"

zplug "mafredri/zsh-async", on:sindresorhus/pure

### AUTOSUGGESTIONS ###
zplug "zsh-users/zsh-completions",              defer:0
zplug "zsh-users/zsh-autosuggestions",          defer:2, on:"zsh-users/zsh-completions"
zplug "zsh-users/zsh-syntax-highlighting",      defer:3, on:"zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-history-substring-search", defer:3, on:"zsh-users/zsh-syntax-highlighting"

if zplug check zsh-users/zsh-autosuggestions; then
  ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(history-substring-search-up history-substring-search-down) # Add history-substring-search-* widgets to list of widgets that clear the autosuggestion
  ZSH_AUTOSUGGEST_CLEAR_WIDGETS=("${(@)ZSH_AUTOSUGGEST_CLEAR_WIDGETS:#(up|down)-line-or-history}") # Remove *-line-or-history widgets from list of widgets that clear the autosuggestion to avoid conflict with history-substring-search-* widgets
fi

### PROMPT ####
zplug "bhilburn/powerlevel9k", use:powerlevel9k.zsh-theme

if ! zplug check; then
	zplug install
fi

zplug load

if zplug check "creationix/nvm" && [[ $(command -v nvm) ]] && [[ $(nvm current) == "system" ]]; then
	echo "Installing nvm latest node.js version"
	nvm install node
	nvm alias default node
fi

if zplug check "zsh-users/zsh-history-substring-search"; then
	bindkey '^[[A' history-substring-search-up
	bindkey '^[[B' history-substring-search-down
fi

if [[ $(command -v rbenv) ]]; then
	eval "$(rbenv init - --no-rehash zsh)"
fi

if [[ $(command -v npm) ]]; then
	. <(npm completion)
fi

if [[ $(command -v fasd) ]]; then
	eval "$(fasd --init posix-alias zsh-hook zsh-ccomp zsh-ccomp-install zsh-wcomp zsh-wcomp-install)"
fi

if [[ $(command -v kubectl) ]]; then
    . <(kubectl completion zsh)
fi

[[ -f "${HOME}/.aliases" ]] && source "${HOME}/.aliases"
[[ -f "${HOME}/.completions" ]] && source "${HOME}/.completions"
[[ -f "${HOME}/.extra" ]] && source "${HOME}/.extra"

# Customise the Powerlevel9k prompts
POWERLEVEL9K_MODE='nerdfont-complete'
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
	dir
	vcs
	newline
	status
)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
	battery
    load
    rspec_stats
)
POWERLEVEL9K_PROMPT_ADD_NEWLINE=true

POWERLEVEL9K_CUSTOM_JAVASCRIPT="echo -n '\ue781' JavaScript"
POWERLEVEL9K_CUSTOM_JAVASCRIPT_FOREGROUND="black"
POWERLEVEL9K_CUSTOM_JAVASCRIPT_BACKGROUND="yellow"

POWERLEVEL9K_CUSTOM_PYTHON="echo -n '\uf81f' Python"
POWERLEVEL9K_CUSTOM_PYTHON_FOREGROUND="black"
POWERLEVEL9K_CUSTOM_PYTHON_BACKGROUND="blue"

POWERLEVEL9K_CUSTOM_RUBY="echo -n '\ue21e' Ruby"
POWERLEVEL9K_CUSTOM_RUBY_FOREGROUND="black"
POWERLEVEL9K_CUSTOM_RUBY_BACKGROUND="red"

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

export GUILE_LOAD_PATH="/usr/local/share/guile/site/3.0"
export GUILE_LOAD_COMPILED_PATH="/usr/local/lib/guile/3.0/site-ccache"
export GUILE_SYSTEM_EXTENSIONS_PATH="/usr/local/lib/guile/3.0/extensions"

export NVM_SYMLINK_CURRENT=true
export NVM_DIR=~/.nvm
source $(brew --prefix nvm)/nvm.sh

# pyenv
if [[ $(command -v pyenv) ]]; then
	export PYENV_ROOT="$HOME/.pyenv"
	export PATH="$PYENV_ROOT/bin:$PATH"
	eval "$(pyenv init -)"
fi

source /Users/aeldaly/.rvm/scripts/rvm
source /usr/local/opt/chruby/share/chruby/chruby.sh

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
export PATH="/usr/local/opt/ruby@3.0/bin:$PATH"
