#!/bin/zsh

# we will be using this all throughout this file
setopt EXTENDED_GLOB

: ${ZDOTDIR:=$HOME/.config/zsh}
: ${ZPLUGINDIR:=${ZDOTDIR:-~/.config/zsh}/plugins}

# Set up direnv, instant propt and p10k configuration
(( ${+commands[direnv]} )) && emulate zsh -c "$(direnv export zsh)"

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

(( ${+commands[direnv]} )) && emulate zsh -c "$(direnv hook zsh)"

[[ ! -f ${ZDOTDIR}/.p10k.zsh ]] || source ${ZDOTDIR}/.p10k.zsh

# Set up fpath and plugins
typeset -U path cdpath fpath manpath

# user functions come first
# NOTE: this overwrites some stuff depending on what is in the directory,
# notably preexec, precmd and some zle functions
fpath=("${ZDOTDIR}/functions" $fpath)

fpath+="$HOME/.local/bin/completions"
(( ${+commands[brew]} )) && fpath+="$(brew --prefix)/share/zsh/site-functions"

# compile and autoload all custom functions
for file in ${ZDOTDIR}/functions/^*.zwc ; do
    [[ ! "$file".zwc -nt "$file" ]] && print "Compiling $file" && zcompile -R -- "$file".zwc "$file"
done
autoload ${ZDOTDIR}/functions/*(:t)

load-plugin romkatv/powerlevel10k
load-plugin zsh-users/zsh-completions
load-plugin zsh-users/zsh-syntax-highlighting
load-plugin zsh-users/zsh-autosuggestions

# Completion
[[ -d $HOME/.cache/zsh ]] || mkdir -p $HOME/.cache/zsh

autoload -Uz compinit
compinit -C -d $HOME/.cache/zsh/zcompdump-$EUID-$ZSH_VERSION
if [[ $EUID != 0 ]]; then
    zstyle ':completion:*' use-cache yes
    zstyle ':completion:*' cache-path $HOME/.cache/zsh/zcompcache
    if [[ ! -e $HOME/.cache/zsh/zcompcache ]]; then
        mkdir -m 0700 -p $HOME/.cache/zsh/zcompcache
    fi
fi
zstyle ':completion:*' menu select
# Case-insensitive, partial-word and substring completion
# https://zsh.sourceforge.io/Guide/zshguide06.html#l174
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# complete all make targets
zstyle ':completion:*:make:*:targets' call-command true
zstyle ':completion:*:*:make:*' tag-order 'targets'

setopt COMPLETE_ALIASES

HISTSIZE="1200000"
SAVEHIST="1000000"

HISTFILE="$HOME/.cache/zsh/history"
mkdir -p "$(dirname "$HISTFILE")"

setopt HIST_FCNTL_LOCK
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
unsetopt HIST_EXPIRE_DUPS_FIRST
setopt SHARE_HISTORY

# timestamps in history
setopt EXTENDED_HISTORY

# Don't let > overwrite files. To overwrite, use >| instead.
setopt NO_CLOBBER

# Allow comments to be pasted into the command line.
setopt INTERACTIVE_COMMENTS

# Don't treat non-executable files in your $path as commands.
setopt HASH_EXECUTABLES_ONLY

# Enable ** and *** as shortcuts for **/* and ***, respectively.
# https://zsh.sourceforge.io/Doc/Release/Expansion.html#Recursive-Globbing
setopt GLOB_STAR_SHORT

# Sort numbers numerically, not lexicographically.
setopt NUMERIC_GLOB_SORT

# No beeps
unsetopt LIST_BEEP

# use ctrl+n to accept next word from zsh-autosuggestions
bindkey "^n" forward-word

# use arrows to history substring search (if on the first line)
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search
bindkey "^[OA" up-line-or-beginning-search
bindkey "^[OB" down-line-or-beginning-search

# Use viins keymap as the default.
bindkey -v

# Change cursor shape for different vi modes.
zle -N zle-keymap-select
zle -N zle-line-init

# Edit command in $EDITOR
zle -N edit-command-line
autoload -Uz edit-command-line
bindkey -M vicmd 'z' edit-command-line

# Backspace should work as in vim
WORDCHARS=''
bindkey -v '^?' backward-delete-char
bindkey -v '^H' backward-delete-word
KEYTIMEOUT=1

# Aliases
alias :q='exit'
alias :wq='exit'
alias cd..='cd ..'
alias g='git'
alias ls='ls --color=auto'
alias lsd='lsd -lah'
alias notes='zk edit -i'
alias nn='new-note'
alias wttr='curl wttr.in/heidelberg'
alias tm='tmux new-session -As default'
alias p='list-procs'
alias ws='web-search'

# Named Directory Hashes
hash -d a="/run/media/alexandria"
hash -d c="$XDG_CONFIG_HOME"
hash -d dot="$HOME/.dotfiles"
hash -d d="$HOME/Data"
hash -d e="$HOME/Experiments"
hash -d np="$HOME/NetworkDrives/E130-Personal/Bungert"
hash -d nvim="$XDG_CONFIG_HOME/nvim"
hash -d p="$HOME/Projects"
hash -d zsh="$ZDOTDIR"

# Functions + Widgets
zle -N open-project
ZSH_AUTOSUGGEST_IGNORE_WIDGETS+=open-project
bindkey '^f' open-project

# Start SSH Agent
if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
    if ! (pgrep -a -u $USER '^ssh-agent' | grep -v gcr) >/dev/null;then
        ssh-agent -t 1h >! "$XDG_RUNTIME_DIR/ssh-agent.env"
    fi

    if [[ ! -f "$SSH_AUTH_SOCK" ]]; then
        source "$XDG_RUNTIME_DIR/ssh-agent.env" >/dev/null
    fi
fi

# FZF
export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,spinner:#F5E0DC,hl:#F38BA8 \
--color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC \
--color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8 \
--color=selected-bg:#45475A \
--color=border:#6C7086,label:#CDD6F4"
# Go install
if [ -f ~/.fzf.zsh ]; then
    source ~/.fzf.zsh
fi
# brew install
if [[ -v commands[brew] ]]; then
    if [ -f $(brew --prefix)/opt/fzf/shell/key-bindings.zsh ]; then
        source $(brew --prefix)/opt/fzf/shell/key-bindings.zsh
    fi
    if [ -f $(brew --prefix)/opt/fzf/shell/completion.zsh ]; then
        source $(brew --prefix)/opt/fzf/shell/completion.zsh
    fi
fi
# apt install
if [ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]; then
    source /usr/share/doc/fzf/examples/key-bindings.zsh
fi
if [ -f /usr/share/doc/fzf/examples/completion.zsh ]; then
    source /usr/share/doc/fzf/examples/completion.zsh
fi
# pacman install
if [ -f /usr/share/fzf/key-bindings.zsh ]; then
    source /usr/share/fzf/key-bindings.zsh
fi
if [ -f /usr/share/fzf/completion.zsh ]; then
    source /usr/share/fzf/completion.zsh
fi
