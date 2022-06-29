# Only source this once.
if [ -n "$__HM_SESS_VARS_SOURCED" ]; then return; fi
export __HM_SESS_VARS_SOURCED=1

export BROWSER="brave"
export EDITOR="nvim"
export GITLAB_HOST="gitlab.hzdr.de"
export MANPAGER="nvim +Man!"
export TERMINAL="kitty"
export VISUAL="nvim"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export ZK_NOTEBOOK_DIR="$HOME/wiki"
eval "$(/opt/homebrew/bin/brew shellenv)"
export PATH="$PATH${PATH:+:}:$HOME/.cargo/bin:$HOME/.local/bin"
. "$HOME/.cargo/env"
