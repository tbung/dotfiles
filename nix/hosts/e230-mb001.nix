{ config, pkgs, ... }:

{
  users = {
    users.tillb = {
      name = "tillb";
      home = "/Users/tillb";
      shell = pkgs.zsh;
    };
  };

  environment.systemPackages =
    [
      pkgs.vim
    ];

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      system = aarch64-darwin
      extra-platforms = aarch64-darwin x86_64-darwin
      experimental-features = nix-command flakes
      auto-optimise-store = true
    '';
    binaryCaches = [
      "https://nix-community.cachix.org"
    ];
    binaryCachePublicKeys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina
  # programs.fish.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToControl = true;

  home-manager = {
    useGlobalPkgs = true;
    users.tillb = import ../macos.nix;
  };

  homebrew = {
    enable = true;
    cleanup = "zap";
    global = {
      brewfile = true;
      noLock = true;
    };
    taps = [ "homebrew/cask" ];
    brews = [
      "openconnect"
    ];
    casks = [
      "brave-browser"
      "firefox"
      "gimp"
      "hammerspoon"
      "inkscape"
      "kitty"
      "macfuse"
      "mpv"
      "obsidian"
      "scroll-reverser"
      "slack"
      "spotify"
      "visual-studio-code"
      "zoom"
      "zotero"
    ];
  };

}
