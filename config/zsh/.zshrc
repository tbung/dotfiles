#!/bin/zsh

(( ${+commands[direnv]} )) && eval "$(direnv hook zsh)"
[[ -v DIRENV_DIR ]] && direnv reload

function prompt_my_tmux() {
    p10k segment -t $'%BTMUX%b' -f 'red' -c "$TMUX"
}

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
(( ${+commands[direnv]} )) && emulate zsh -c "$(direnv export zsh)"
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh

# where do you want to store your plugins?
ZPLUGINDIR=${ZPLUGINDIR:-${ZDOTDIR:-$HOME/.config/zsh}/plugins}

# get zsh_unplugged and store it with your other plugins
if [[ ! -d $ZPLUGINDIR/zsh_unplugged ]]; then
  git clone --quiet https://github.com/mattmc3/zsh_unplugged $ZPLUGINDIR/zsh_unplugged
fi
source $ZPLUGINDIR/zsh_unplugged/zsh_unplugged.zsh

# make list of the Zsh plugins you use
repos=(
  # plugins that you want loaded first
  romkatv/powerlevel10k

  # other plugins
  zsh-users/zsh-completions

  # plugins you want loaded last
  zsh-users/zsh-syntax-highlighting
  zsh-users/zsh-autosuggestions
)

# now load your plugins
plugin-load $repos

# use ctrl+n to accept next word from zsh-autosuggestions
bindkey "^n" forward-word


# Python conda
[[ -d ~/miniconda3 ]] && source $HOME/miniconda3/etc/profile.d/conda.sh
[[ -d ~/mambaforge ]] && source $HOME/mambaforge/etc/profile.d/conda.sh
[[ -d ~/mambaforge ]] && source $HOME/mambaforge/etc/profile.d/mamba.sh


function _tmux_sessionizer () {
    BUFFER="tmux-sessionizer"
    zle accept-line
}
zle -N _tmux_sessionizer
bindkey '^f' _tmux_sessionizer




typeset -U path cdpath fpath manpath



fpath+="$HOME/.local/bin/completions"

# Use viins keymap as the default.
bindkey -v

# FZF
# Go install
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# brew install
(( ${+commands[brew]} )) && [ -f $(brew --prefix)/opt/fzf/shell/key-bindings.zsh ] && source $(brew --prefix)/opt/fzf/shell/key-bindings.zsh
(( ${+commands[brew]} )) && [ -f $(brew --prefix)/opt/fzf/shell/completion.zsh ] && source $(brew --prefix)/opt/fzf/shell/completion.zsh
# apt install
[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ] && source /usr/share/doc/fzf/examples/key-bindings.zsh
[ -f /usr/share/doc/fzf/examples/completion.zsh ] && source /usr/share/doc/fzf/examples/completion.zsh
# pacman install
[ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh
[ -f /usr/share/fzf/completion.zsh ] && source /usr/share/fzf/completion.zsh

[[ -d $HOME/.cache/zsh ]] || mkdir -p $HOME/.cache/zsh


path+="$HOME/.config/zsh/plugins/powerlevel10k"
fpath+="$HOME/.config/zsh/plugins/powerlevel10k"
(( ${+commands[brew]} )) && fpath+="$(brew --prefix)/share/zsh/site-functions"


# Oh-My-Zsh/Prezto calls compinit during initialization,
# calling it twice causes slight start up slowdown
# as all $fpath entries will be traversed again.
autoload -Uz compinit
compinit -d $HOME/.cache/zsh/zcompdump-$ZSH_VERSION
zstyle ':completion:*' menu select
zstyle ':completion:*' cache-path $HOME/.cache/zsh/zcompcache
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
setopt COMPLETE_ALIASES

# History options should be set in .zshrc and after oh-my-zsh sourcing.
# See https://github.com/nix-community/home-manager/issues/177.
HISTSIZE="1200000"
SAVEHIST="1000000"

HISTFILE="$HOME/.cache/zsh/history"
mkdir -p "$(dirname "$HISTFILE")"

setopt HIST_FCNTL_LOCK
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
unsetopt HIST_EXPIRE_DUPS_FIRST
setopt SHARE_HISTORY
unsetopt EXTENDED_HISTORY


# Don't let > overwrite files. To overwrite, use >| instead.
setopt NO_CLOBBER

# Allow comments to be pasted into the command line.
setopt INTERACTIVE_COMMENTS

# Don't treat non-executable files in your $path as commands.
setopt HASH_EXECUTABLES_ONLY

# Enable additional glob operators. (Globbing = pattern matching)
# https://zsh.sourceforge.io/Doc/Release/Expansion.html#Filename-Generation
setopt EXTENDED_GLOB

# Enable ** and *** as shortcuts for **/* and ***, respectively.
# https://zsh.sourceforge.io/Doc/Release/Expansion.html#Recursive-Globbing
setopt GLOB_STAR_SHORT

# Sort numbers numerically, not lexicographically.
setopt NUMERIC_GLOB_SORT

# Edit command in vim
zle -N edit-command-line
autoload -Uz edit-command-line
bindkey -M vicmd 'v' edit-command-line

# Backspace should work as in vim
bindkey -v '^?' backward-delete-char
KEYTIMEOUT=1

function dkfz-vpn-up() {
  echo "Starting the vpn ..."
  sudo openconnect --background --user=t974t gate.dkfz-heidelberg.de
}

function dkfz-vpn-down() {
  sudo kill -2 `pgrep openconnect`
}

if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
    export SSH_AUTH_SOCK=$HOME/.ssh/ssh_auth_sock
fi

(( ${+commands[zoxide]} )) && eval "$(zoxide init zsh)"

# Aliases
alias :q='exit'
alias :wq='exit'
alias cd..='cd ..'
alias g='git'
alias ga='git add'
alias gap='git add --patch'
alias gc='git commit'
alias gpl='git pull'
alias gps='git push'
alias gs='git status'
alias ls='ls --color=auto'
alias lsd='lsd -lah'
(( ${+commands[nvim]} )) && alias vim='nvim'
alias wiki='vim ~/wiki/index.md'
alias wttr='curl wttr.in/heidelberg'

# Global Aliases


# Named Directory Hashes
hash -d p="$HOME/Projects"
hash -d z="$ZDOTDIR"
hash -d c="$XDG_CONFIG_HOME"
hash -d d="$HOME/Data"
hash -d e="$HOME/Experiments"
hash -d np="$HOME/NetworkDrives/E130-Personal/Bungert"

export GPG_TTY=$(tty)

DISABLE_AUTO_TITLE="true"
