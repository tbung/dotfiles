umask 022

export XDG_CONFIG_HOME="$HOME/.config"
export BROWSER=/usr/bin/brave
export TERMINAL=/usr/bin/kitty
export EDITOR=/usr/bin/nvim
export VISUAL=/usr/bin/nvim
export SHELL=/bin/zsh
export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
export GITLAB_HOST=gitlab.hzdr.de
export ZK_NOTEBOOK_DIR="$HOME/wiki"

export QT_QPA_PLATFORMTHEME="gnome"
export CHROME_DEVEL_SANDBOX=/usr/lib/chromium/chrome-sandbox
export _JAVA_AWT_WM_NONREPARENTING=1

# Termcap is outdated, old, and crusty, kill it.
unset TERMCAP

# Man is much better than us at figuring this out
unset MANPATH
