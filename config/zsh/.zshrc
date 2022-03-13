#!/bin/zsh

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
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
export MAMBA_EXE="/Users/tillb/mambaforge/bin/micromamba";
export MAMBA_ROOT_PREFIX="/Users/tillb/mambaforge";
__mamba_setup="$('/Users/tillb/mambaforge/bin/micromamba' shell hook --shell zsh --prefix '/Users/tillb/mambaforge' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__mamba_setup"
else
    if [ -f "/Users/tillb/mambaforge/etc/profile.d/micromamba.sh" ]; then
        . "/Users/tillb/mambaforge/etc/profile.d/micromamba.sh"
    else
        export  PATH="/Users/tillb/mambaforge/bin:$PATH"  # extra space after export prevents interference from conda init
    fi
fi
unset __mamba_setup
# <<< mamba initialize <<<
