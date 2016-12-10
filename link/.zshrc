setopt no_beep # Disable sound
setopt glob_dots # glob for dotfiles as well (hidden)
setopt share_history
setopt inc_append_history
setopt hist_ignore_all_dups
setopt extended_history
setopt hist_ignore_space

export DOTFILES="${HOME}/.dotfiles"
export PATH="/usr/local/bin:/usr/local/sbin:$PATH"
export CACHE_DIR="${HOME}/.cache"
[[ ! -d "${CACHE_DIR}" ]] && mkdir -p "${CACHE_DIR}"

# set fasd cache dir
export _FASD_DATA="${CACHE_DIR}/.fasd" # set fasd data file location
export ZPLUG_HOME="${HOME}/.zplug"
export NODE_REPL_HISTORY_FILE="${HOME}/.node_history"

export MANPAGER='less -X'; # Don't clear the screen after quitting a manual page.
export LESS_TERMCAP_md="${yellow}" # Highlight section titles in manual pages.

# Always enable colored `grep` output.
export GREP_OPTIONS='--color=auto';
export JOBS=max # tell npm to install concurrently
export EDITOR=vim
export VISUAL=vim

export SSH_KEY_PATH="${HOME}/.ssh"
export AWS_CONFIG_FILE="${HOME}/.aws/config"
export AWS_DEFAULT_PROFILE="default"
export ANDROID_HOME=/usr/local/opt/android-sdk

# history settings
export HISTSIZE=100000
export SAVEHIST=100000
export HISTFILESIZE=$HISTSIZE
export HISTCONTROL=ignoredups
export HISTFILE="${CACHE_DIR}/.zsh_history"
export HISTIGNORE="ls:cd:cd -:pwd:exit:date:* --help"

# set the correct term with TMUX
if [[ -n "${TMUX}" ]]; then
    export TERM=screen-256color
else
    export TERM=xterm-256color
fi

# language settings
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

zstyle ':zplug:tag' depth 42

if [[ ! -d "${ZPLUG_HOME}" ]]; then
    echo "Installing zplug"
    curl --progress-bar -sL zplug.sh/installer | zsh
    source "${ZPLUG_HOME}/init.zsh"
    zplug update --self
else
    source "${ZPLUG_HOME}/init.zsh"
fi

fpath=(${DOTFILES}/zsh/completions $fpath)

# zplug "zplug/zplug"

zplug "creationix/nvm", use:nvm.sh
zplug "robbyrussell/oh-my-zsh", use:"plugins/{git-extras,tmuxinator,vagrant}"
zplug "robbyrussell/oh-my-zsh", use:"lib/{key-bindings,completion,directories}.zsh"

zplug "zsh-users/zsh-history-substring-search"
zplug "zsh-users/zsh-syntax-highlighting", defer:3

zplug "simnalamburt/shellder", as:theme

zplug check || zplug install
zplug load

if zplug check "creationix/nvm" && [[ $(nvm current) == "none" ]]; then
    nvm install node
    nvm alias default node
fi

if which rbenv &> /dev/null; then
    eval "$(rbenv init - zsh --no-rehash)"
fi

[[ -f "${HOME}/.aliases" ]] && source "${HOME}/.aliases"
[[ -f "${HOME}/.completions" ]] && source "${HOME}/.completions"
[[ -f "${HOME}/.extra" ]] && source "${HOME}/.extra"
