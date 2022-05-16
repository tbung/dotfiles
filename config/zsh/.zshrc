#!/bin/zsh

if [[ -z "$TMUX"  && -z "$VIM" && "$TERM_PROGRAM" != "vscode" ]] && [[ -n "$SSH_TTY" ]]; then
  tmux new-session -A -s main
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
(( ${+commands[direnv]} )) && emulate zsh -c "$(direnv export zsh)"
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh


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


# >>> mamba initialize >>>
# !! Contents within this block are managed by 'mamba init' !!
export MAMBA_ROOT_PREFIX="${HOME}/.mamba";
export MAMBA_EXE="${MAMBA_ROOT_PREFIX}/bin/micromamba";
__mamba_setup="$($MAMBA_ROOT_PREFIX'/bin/micromamba' shell hook --shell zsh --prefix $MAMBA_ROOT_PREFIX 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__mamba_setup"
else
    if [ -f "${MAMBA_ROOT_PREFIX}/etc/profile.d/micromamba.sh" ]; then
        . "${MAMBA_ROOT_PREFIX}/etc/profile.d/micromamba.sh"
    else
        export  PATH="${MAMBA_ROOT_PREFIX}/bin:$PATH"  # extra space after export prevents interference from conda init
    fi
fi
unset __mamba_setup
# <<< mamba initialize <<<
