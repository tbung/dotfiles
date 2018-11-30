# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/tillb/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# Path extensions
export PATH=$HOME/bin:$PATH

fpath=($HOME/.zsh/zsh-completions/src $fpath)
fpath=($HOME/.zsh $fpath)

# source $HOME/.zsh/git-completion.zsh
source $HOME/.zsh/aliases.zsh
source $HOME/.zsh/functions.zsh
source $HOME/.zsh/vi-mode.zsh

autoload -U promptinit; promptinit
SPACESHIP_PROMPT_ORDER=(
  time          # Time stamps section
  user          # Username section
  dir           # Current directory section
  host          # Hostname section
  git           # Git section (git_branch + git_status)
  package       # Package version
  node          # Node.js section
  docker        # Docker section
  conda         # conda virtualenv section
  exec_time     # Execution time
  line_sep      # Line break
  vi_mode       # Vi-mode indicator
  jobs          # Background jobs indicator
  exit_code     # Exit code section
  char          # Prompt character
)
prompt spaceship

# Plugins
source $HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $HOME/.zsh/k/k.sh

# Always activate conda base env
[ -d ~/miniconda3 ] && source $HOME/miniconda3/etc/profile.d/conda.sh
[[ -z $TMUX ]] || conda deactivate; conda activate base

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type d . $HOME"
