# Commands that should be applied only for interactive shells.
[[ $- == *i* ]] || return

if [[ -z "$TMUX"  && -z "$VIM" && "$TERM_PROGRAM" != "vscode" ]] && [[ -n "$SSH_TTY" ]]; then
  tmux new-session -A -s main
fi

HISTFILESIZE=100000
HISTSIZE=10000

shopt -s histappend
shopt -s checkwinsize
shopt -s extglob
shopt -s globstar
shopt -s checkjobs


eval "$(zoxide init bash )"

eval "$(direnv hook bash)"


[ -f ~/.fzf.bash ] && source ~/.fzf.bash
