{ pkgs, ... }:

with pkgs;

{

  programs.tmux = {
    enable = true;

    shell = "${pkgs.zsh.outPath}/bin/zsh";
    terminal = "xterm-kitty";

    baseIndex = 1;

    escapeTime = 0;
    keyMode = "vi";

    prefix = "C-space";

    # newSession = true;

    extraConfig = builtins.readFile ../../config/tmux/tmux.conf;
  };

}

