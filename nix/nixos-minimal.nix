{ config, pkgs, ... }:

{
  imports = [
    (import ./common.nix)
  ];
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  # home.username = "tillb";
  # home.homeDirectory = "/home/tillb";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  # home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    coreutils-full
    curl
    gcc
    cmake
    gnumake

    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji

    brave
    firefox
    kitty

    neofetch
  ];

  home.sessionVariables = {
    TERMINFO_DIRS = "${pkgs.kitty.terminfo.outPath}/share/terminfo";
  };

  programs.kitty = {
    font.size = pkgs.lib.mkForce 14;

    settings = {
      hide_window_decorations = true;
    };
  };

  xdg.configFile."bspwm/bspwmrc".text = ''
    #!/usr/bin/env sh

    bspc monitor -d I II III IV V VI VII VIII IX X

    bspc config border_width         2
    bspc config window_gap          12

    bspc config split_ratio          0.5
    bspc config borderless_monocle   true
    bspc config gapless_monocle      true

    kitty &
  '';

}


