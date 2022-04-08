{ inputs, config, lib, pkgs, ... }:
{
  nixpkgs.overlays = [ inputs.neovim-nightly-overlay.overlay ];
  nixpkgs.config = {
    allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
      "discord"
      "nvidia-settings"
      "nvidia-x11"
      "obsidian"
      "slack"
      "spotify"
      "spotify-unwrapped"
      "steam"
      "steam-original"
      "steam-runtime"
      "vscode"
      "zoom"
    ];
  };

  # nix = {
  #   package = pkgs.nixUnstable;
  #   extraOptions = ''
  #     experimental-features = nix-command flakes
  #   '';
  #   settings = {
  #     substituters = [
  #       "https://nix-community.cachix.org"
  #     ];
  #     trusted-public-keys = [
  #       "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
  #     ];
  #     auto-optimise-store = true;
  #   };
  # };
}
