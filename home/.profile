export BROWSER="brave"
export EDITOR="nvim"
export GITLAB_HOST="gitlab.hzdr.de"
export MANPAGER="nvim +Man!"
export TERMINAL="kitty"
export VISUAL="nvim"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export ZK_NOTEBOOK_DIR="$HOME/wiki"

if [[ $(uname -s) == "Darwin" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
    PATH="/opt/homebrew/opt/coreutils/libexec/gnubin${PATH:+:}$PATH"
    export MANPATH="/opt/homebrew/opt/coreutils/libexec/gnuman:$MANPATH"
fi

export PATH="$PATH${PATH:+:}$HOME/.cargo/bin:$HOME/.local/bin"
source "$HOME/.cargo/env"

# >>> mamba initialize >>>
# !! Contents within this block are managed by 'mamba init' !!
export MAMBA_ROOT_PREFIX="${HOME}/.mamba";
export MAMBA_EXE="${MAMBA_ROOT_PREFIX}/bin/micromamba";
__mamba_setup="$($MAMBA_ROOT_PREFIX'/bin/micromamba' shell hook --shell zsh --prefix $MAMBA_ROOT_PREFIX 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__mamba_setup"
else
    if [ -f "${MAMBA_ROOT_PREFIX}/etc/profile.d/micromamba.sh" ]; then
        . "${MAMBA_ROOT_PREFIX}/etc/profile.d/micromamba.sh"
    else
        export  PATH="${MAMBA_ROOT_PREFIX}/bin:$PATH"  # extra space after export prevents interference from conda init
    fi
fi
unset __mamba_setup
# <<< mamba initialize <<<
