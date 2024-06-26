export BROWSER="firefox"
export EDITOR="nvim"
export GITLAB_HOST="codebase.helmholtz.cloud"
export MANPAGER="nvim +Man!"
export TERMINAL="kitty"
export VISUAL="nvim"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export ZK_NOTEBOOK_DIR="$HOME/wiki"

# if $TERM got set to something not available, set it to xterm
infocmp "$TERM" &>/dev/null || export TERM="xterm-256color"
if [[ $(uname -s) == "Darwin" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
    export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin${PATH:+:}$PATH"
    export MANPATH="/opt/homebrew/opt/coreutils/libexec/gnuman:$MANPATH"
fi

export PATH="$HOME/.local/bin${PATH:+:}$PATH"
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
command -v pyenv >/dev/null && eval "$(pyenv init -)"

