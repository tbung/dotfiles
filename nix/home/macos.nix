{ config, pkgs, ... }:

{
  imports = [
    (import ./common.nix)
  ];

  home.username = "tillb";
  home.homeDirectory = "/Users/tillb";

  home.packages = with pkgs; [
  ];

  home.sessionPath = [
    "/opt/homebrew/bin"
  ];

  # Kitty is installed via homebrew
  programs.kitty = {
    package = pkgs.runCommand "kitty-0.0.0" { } "mkdir $out";
    font.size = pkgs.lib.mkForce 18;
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
