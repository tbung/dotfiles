{ pkgs, ... }:

with pkgs;

{

  # xdg.configFile."kitty".source = ../config/kitty;

  programs.kitty = {
    enable = true;
    # theme = "Tokyo Night";
    theme = "Catppuccin";
    font = {
      name = "VictorMono Nerd Font";
      size = 15;
    };

    settings = {
      enable_audio_bell = false;
      enabled_layouts = "tall,grid,splits";
      # hide_window_decorations = true;
      window_padding_width = 10;
      allow_remote_control = true;
      shell_integration = "enabled";
    };

    keybindings = {
      "ctrl+space>ctrl+space" = "send_text all \\x00";
      "ctrl+space>f" = "launch --type=overlay --copy-env kitty-sessionizer";
      "ctrl+space>s" = "launch --cwd=current";
      "ctrl+space>t" = "launch --type=tab";
      "ctrl+space>h" = "neighboring_window left";
      "ctrl+space>j" = "neighboring_window down";
      "ctrl+space>k" = "neighboring_window up";
      "ctrl+space>l" = "neighboring_window right";
      "ctrl+space>p" = "previous_tab";
      "ctrl+space>n" = "next_tab";
      "ctrl+space>;" = "goto_tab -1";
      "ctrl+space>1" = "goto_tab 1";
      "ctrl+space>2" = "goto_tab 2";
      "ctrl+space>3" = "goto_tab 3";
      "ctrl+space>4" = "goto_tab 4";
      "ctrl+space>5" = "goto_tab 5";
    };

  };

}
