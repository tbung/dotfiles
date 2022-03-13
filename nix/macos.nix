{ config, pkgs, ... }:

{
  imports = [
    (import ./common.nix)
  ];
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "tillb";
  home.homeDirectory = "/Users/tillb";

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
    # pkgs is the set of all packages in the default home.nix implementation
    coreutils
  ];


  home.sessionPath = [
    "/opt/homebrew/bin"
  ];

  programs.kitty = {
    package = pkgs.runCommand "kitty-0.0.0" { } "mkdir $out";
    font.size = pkgs.lib.mkForce 16;
  };

  # On macos, only the builtin ssh uses the keychain
  programs.git = {
    extraConfig = {
      core = {
        sshCommand = "/usr/bin/ssh";
      };
    };
  };

}
