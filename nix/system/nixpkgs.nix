{ inputs, config, lib, pkgs, ... }:
{
  nixpkgs.overlays = [
    inputs.neovim-nightly-overlay.overlay
    (final: prev: rec {
      python310 = prev.python310.override {
        packageOverrides = final: prev: {
          pylsp-mypy = prev.pylsp-mypy.overrideAttrs (old:
          {
            disabledTests = [
              "test_multiple_workspaces"
              "test_option_overrides_dmypy"
            ];
          });
        };
      };
      python310Packages = python310.pkgs;
    })
  ];
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
