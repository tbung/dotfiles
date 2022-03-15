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

    gnome.gnome-tweaks

    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji

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
    discord
  ];

  home.sessionVariables = {
    TERMINFO_DIRS = "${pkgs.kitty.terminfo.outPath}/share/terminfo";
  };

  programs.zsh.sessionVariables = {
    GNOME_KEYRING_CONTROL = "/run/user/1000/keyring";
    SSH_AUTH_SOCK = "/run/user/1000/keyring/ssh";
  };

  programs.kitty = {
    font.size = pkgs.lib.mkForce 14;

    settings = {
      hide_window_decorations = true;
    };
  };

}

