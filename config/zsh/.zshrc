# History in cache directory:
HISTSIZE=10000000
SAVEHIST=10000000
HISTFILE=~/.cache/zsh/history

# Enable completion
autoload -Uz compinit
compinit -d ~/.cache/zsh/zcompdump-$ZSH_VERSION
zstyle ':completion:*' menu select

# Add completions to fpath
fpath=(/usr/share/zsh/plugins/zsh-completions/src $fpath)

# Prompt
autoload -U promptinit; promptinit
SPACESHIP_PROMPT_ORDER=(
  time          # Time stamps section
  user          # Username section
  dir           # Current directory section
  host          # Hostname section
  git           # Git section (git_branch + git_status)
  node          # Node.js section
  conda         # conda virtualenv section
  line_sep      # Line break
  vi_mode       # Vi-mode indicator
  jobs          # Background jobs indicator
  char          # Prompt character
)
SPACESHIP_CHAR_SYMBOL="❯ "
prompt spaceship

# Aliases, functions, keymaps
source $ZDOTDIR/aliases.zsh
source $ZDOTDIR/functions.zsh

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

# Plugins
if [[ -r "/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
[[ -r "/usr/share/z/z.sh" ]] && source /usr/share/z/z.sh

# Python conda
[[ -d ~/miniconda3 ]] && source $HOME/miniconda3/etc/profile.d/conda.sh

# FZF commands
[[ -r /usr/share/fzf/key-bindings.zsh ]] && source /usr/share/fzf/key-bindings.zsh
[[ -r /usr/share/fzf/completion.zsh ]] && source /usr/share/fzf/completion.zsh
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
