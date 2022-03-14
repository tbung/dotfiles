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
    brave
    firefox
    gimp
    inkscape
    kitty
    obsidian
    slack
    spotify
    vscode
    zoom-us
    zotero
  ];

  home.sessionVariables = {
    TERMINFO_DIRS = "${pkgs.kitty.terminfo.outPath}/share/terminfo";
  };

}

