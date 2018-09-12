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

# Completion
zstyle ':completion:*:*:git:*' script $HOME/.zsh/git-completion.zsh

# Prompt
setopt prompt_subst

source $HOME/.zsh/git-prompt.sh

export GIT_PS1_SHOWDIRTYSTATE=true
export GIT_PS1_SHOWUNTRACKEDFILES=true
export GIT_PS1_SHOWCOLORHINTS=true

if [[ -z "$SSH_CLIENT" ]]; then
    prompt_host=""
else
    prompt_host="($(hostname)) "
fi

export PROMPT=$'%B%F{green}$prompt_host%b%F{blue}%1~%F{242}$(__git_ps1 " [ %s]") %F{red}❯%F{white} '

# Functions
function gi() { curl -L -s https://www.gitignore.io/api/$@; }  # gitignore.io cli
function chrome-app() { google-chrome-stable --app="$1"; }

source $HOME/.zsh/aliases.zsh

# Plugins
source $HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fpath=($HOME/.zsh/zsh-completions/src $fpath)

# Always activate conda base env
source $HOME/miniconda3/etc/profile.d/conda.sh
[[ -z $TMUX ]] || conda deactivate; conda activate base

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type d . $HOME"
