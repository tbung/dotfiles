{ pkgs, ... }:

with pkgs;

{

  programs.tmux = {
    enable = true;

    shell = "zsh";
    terminal = "xterm-kitty";

    baseIndex = 1;

    escapeTime = 0;
    keyMode = "vi";

    newSession = true;

    extraConfig = builtins.readFile ../config/tmux/tmux.conf;
  };

}

