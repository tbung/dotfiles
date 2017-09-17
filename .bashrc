#
# ~/.bashrc
#

# if not running interactively, dont do anything
[[ $- != *i* ]] && return

# git and prompt
# https://github.com/git/git/blob/master/contrib/completion/git-completion.bash
source /usr/share/git/completion/git-completion.bash
# https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh
source /usr/share/git/completion/git-prompt.sh

export GIT_PS1_SHOWDIRTYSTATE=true
export GIT_PS1_SHOWUNTRACKEDFILES=true
export GIT_PS1_SHOWCOLORHINTS=true

# pretty prompt
export PS1='\[\e[0;36m\]\[\e[0;36m\]\W\[\033[0;35m\]$(__git_ps1 " [%s]")\[\e[0m\] \$ '

# added by Miniconda3 4.3.21 installer
export PATH="/home/tillb/miniconda3/bin:$PATH"

alias ls='ls --color=auto'

source /usr/share/fzf/key-bindings.bash
source /usr/share/fzf/completion.bash
