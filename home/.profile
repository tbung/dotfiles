export BROWSER="firefox"

if command -v nvim >/dev/null; then
    export EDITOR="nvim"
    export VISUAL="nvim"
    export MANPAGER="nvim +Man!"
elif command -v vim >/dev/null; then
    export EDITOR="vim"
    export VISUAL="vim"
    export MANPAGER="vim +MANPAGER --not-a-term -"
elif command -v vi >/dev/null; then
    export EDITOR="vi"
    export VISUAL="vi"
fi

export TERMINAL="wezterm"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export ZK_NOTEBOOK_DIR="$HOME/notes"

# if $TERM got set to something not available, set it to xterm
infocmp "$TERM" &>/dev/null || export TERM="xterm-256color"

if [ "$(uname -s)" = "Darwin" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
    export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin${PATH:+:}$PATH"
    export PATH="/opt/homebrew/opt/curl/bin${PATH:+:}$PATH"
    export MANPATH="/opt/homebrew/opt/coreutils/libexec/gnuman:$MANPATH"
fi

export PATH="$HOME/.local/bin${PATH:+:}$PATH"
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"
export PATH="$HOME/.cargo/bin${PATH:+:}$PATH"

# pyenv setup
PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
command -v pyenv >/dev/null && eval "$(pyenv init -)"

# keep vulkan shader cache for faster gaming
command -v steam >/dev/null && export __GL_SHADER_DISK_CACHE_SKIP_CLEANUP=1
