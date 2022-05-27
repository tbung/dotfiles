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
  home.stateVersion = "22.05";

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
    gimp
    inkscape
    kitty
    mpv
    obsidian
    slack
    spotify
    zoom-us
    zotero
    discord

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

  programs.vscode = {
    enable = true;

    extensions = with pkgs.vscode-extensions; [
      # ms-vsliveshare.vsliveshare
      ms-python.python
      ms-vscode-remote.remote-ssh
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [{
      name = "tokyo-night";
      publisher = "enkia";
      version = "0.8.4";
      sha256 = "878984f95bffa3633190d6f7913f602de0cd08643902fc91e67b22ddc1144b95";
    }];

  };

}
