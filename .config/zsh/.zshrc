#!/bin/zsh

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# History
HISTFILE="${HOME}/.cashe/zsh/history"
[[ -d $HISTFILE:h ]] || mkdir -p $HISTFILE:h
SAVEHIST=$(( 1000 * 1000 ))
HISTSIZE=$(( 1.2 * SAVEHIST ))
setopt HIST_FCNTL_LOCK
setopt HIST_IGNORE_ALL_DUPS
setopt SHARE_HISTORY

# Enable completion
autoload -Uz compinit
compinit -d ~/.cache/zsh/zcompdump-$ZSH_VERSION
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
setopt COMPLETE_ALIASES

# `hash -d <name>=<path>` makes ~<name> a shortcut for <path>.
hash -d z=$ZDOTDIR
hash -d p=$HOME/Projects

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


export CONDARC="${XDG_CONFIG_HOME:-$HOME/.config}/conda/condarc"

export PATH=$HOME/.local/bin:$PATH
export PATH=$HOME/.npm-global/bin:$PATH
export PATH=$HOME/go/bin:$PATH

# Vim key bindings
bindkey -v
# Updates editor information when the keymap changes.
function zle-keymap-select() {
  zle reset-prompt
  zle -R
}
zle -N zle-keymap-select
# Edit command in vim
zle -N edit-command-line
autoload -Uz edit-command-line
bindkey -M vicmd 'v' edit-command-line

# Backspace should work as in vim
bindkey -v '^?' backward-delete-char
KEYTIMEOUT=1

# Plugins
if [[ -r "/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
if [[ -r "/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
    source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
if [[ -r "/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
fi
if [[ -r "/usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
    source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi
if [[ -r "/usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme" ]]; then
    source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
fi
if [[ -r "${HOME}/Projects/packages/powerlevel10k/powerlevel10k.zsh-theme" ]]; then
    source ${HOME}/Projects/packages/powerlevel10k/powerlevel10k.zsh-theme
fi
[[ -r $(which zoxide) ]] && eval "$(zoxide init zsh)"

# Python conda
[[ -d ~/miniconda3 ]] && source $HOME/miniconda3/etc/profile.d/conda.sh
[[ -d ~/mambaforge ]] && source $HOME/mambaforge/etc/profile.d/conda.sh

# FZF commands
[[ -r /usr/share/fzf/key-bindings.zsh ]] && source /usr/share/fzf/key-bindings.zsh
[[ -r /usr/share/fzf/completion.zsh ]] && source /usr/share/fzf/completion.zsh
[[ -r /usr/share/doc/fzf/examples/key-bindings.zsh ]] && source /usr/share/doc/fzf/examples/key-bindings.zsh
[[ -r /usr/share/doc/fzf/examples/completion.zsh ]] && source /usr/share/doc/fzf/examples/completion.zsh
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type d . $HOME"

# Dynamically set window title based on running command
autoload -Uz add-zsh-hook

function xterm_title_precmd () {
	print -Pn -- '\e]2;%n@%m %~\a'
	[[ "$TERM" == 'screen'* ]] && print -Pn -- '\e_\005{g}%n\005{-}@\005{m}%m\005{-} \005{B}%~\005{-}\e\\'
}

function xterm_title_preexec () {
	print -Pn -- '\e]2;%n@%m %~ %# ' && print -n -- "${(q)1}\a"
	[[ "$TERM" == 'screen'* ]] && { print -Pn -- '\e_\005{g}%n\005{-}@\005{m}%m\005{-} \005{B}%~\005{-} %# ' && print -n -- "${(q)1}\e\\"; }
}

if [[ "$TERM" == (st*|alacritty*|gnome*|konsole*|putty*|rxvt*|screen*|tmux*|xterm*|kitty*) ]]; then
	add-zsh-hook -Uz precmd xterm_title_precmd
	add-zsh-hook -Uz preexec xterm_title_preexec
fi

[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh

function _tmux_sessionizer () {
    BUFFER="tmux-sessionizer"
    zle accept-line
}
zle -N _tmux_sessionizer
bindkey '^f' _tmux_sessionizer

alias ls='ls --color=auto'
alias cd..='cd ..'
alias :q='exit'
alias :wq='exit'
alias wiki='nvim ~/wiki/index.md'
alias vim='nvim'
alias wttr='curl wttr.in/heidelberg'

alias g='git'
alias ga='git add'
alias gap='git add --patch'
alias gc='git commit'
alias gs='git status'
alias gps='git push'
alias gpl='git pull'

alias tmux="tmux -f $HOME/.config/tmux/tmux.conf"

alias lsd="lsd -lah"
