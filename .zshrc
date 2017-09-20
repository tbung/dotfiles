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

export PATH="/home/tillb/miniconda3/bin:$PATH"
export PATH="~/.npm-global/bin:$PATH"

setopt prompt_subst
source /usr/share/git/completion/git-prompt.sh
zstyle ':completion:*:*:git:*' script /usr/share/git/completion/git-completion.zsh

export GIT_PS1_SHOWDIRTYSTATE=true
export GIT_PS1_SHOWUNTRACKEDFILES=true
export GIT_PS1_SHOWCOLORHINTS=true

export PROMPT=$'%F{blue}%1~%F{242}$(__git_ps1 " [ %s]") %F{magenta}❯%F{white} '

source /usr/share/fzf/key-bindings.zsh
zstyle ':completion:*:*:fzf:*' script /usr/share/fzf/completion.zsh

alias ls='ls --color=auto'


source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
