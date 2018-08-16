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
export PATH=$HOME/.npm-global/bin:$PATH
export PATH=$HOME/miniconda3/bin:$PATH
export PATH=$HOME/go/bin:$PATH
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

# Aliases
alias ls='ls --color=auto'
alias open='xdg-open'
alias devel='tmuxp load devel'
alias whatsapp='google-chrome-stable --app=http://web.whatsapp.com'
alias gsa="find . -maxdepth 1 -mindepth 1 -type d -exec sh -c '(echo {} && cd {} && git status -s && echo)' \;"
alias td="todoist --color"

# Functions
function gi() { curl -L -s https://www.gitignore.io/api/$@; }  # gitignore.io cli
function chrome-app() { google-chrome-stable --app="$1"; }
function pdf() {
    open=zathura

    ag -U -g ".pdf$" \
    | fast-p \
    | fzf --read0 --reverse -e -d $'\t'  \
        --preview-window down:80% --preview '
            v=$(echo {q} | tr " " "|");
            echo -e {1}"\n"{2} | grep -E "^|$v" -i --color=always;
        ' \
    | cut -z -f 1 -d $'\t' | tr -d '\n' | xargs -r --null $open > /dev/null 2> /dev/null
}


# Plugins
source $HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
fpath=($HOME/.zsh/zsh-completions/src $fpath)

# Always activate conda base env
source $HOME/miniconda3/etc/profile.d/conda.sh
conda activate base

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
