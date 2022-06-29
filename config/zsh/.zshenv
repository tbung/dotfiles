# Environment variables
. ~/.profile

# Only source this once
if [[ -z "$__HM_ZSH_SESS_VARS_SOURCED" ]]; then
  export __HM_ZSH_SESS_VARS_SOURCED=1
  export FZF_ALT_C_COMMAND="fd --type d . $HOME"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git"
fi

ZDOTDIR=$HOME/.config/zsh
