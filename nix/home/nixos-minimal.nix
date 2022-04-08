{ config, pkgs, ... }:

with pkgs;

{
  imports = [
    ./shell.nix
    ./git.nix
    ./tmux.nix
  ];

  home.stateVersion = "22.05";

  programs.home-manager.enable = true;

  home.packages = [
    tmux
    htop
    rsync

    git
    git-lfs

    (python310.withPackages (pypkgs: with pypkgs; [
      pynvim
      isort
    ]))
    nodejs
    gcc

    rclone

    gh
    glab

    neovim-nightly
    rnix-lsp

    # modern unix tools
    ripgrep
    fd
    mdcat
    lsd
    zoxide
    delta
    bat

    zsh-powerlevel10k
    zsh-autosuggestions
    zsh-syntax-highlighting
    fzf
  ];


  home.sessionVariables = {
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_CACHE_HOME = "$HOME/.cache";

    EDITOR = "${pkgs.neovim-nightly}/bin/nvim";
    VISUAL = "${pkgs.neovim-nightly}/bin/nvim";

    MANPAGER="nvim +Man!";
  };

  home.sessionPath = [
    "$HOME/.local/bin"
  ];
  home.file.".local/bin".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/local/bin";

  xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/nvim";

  # https://github.com/rycee/home-manager/issues/432
  home.extraOutputsToInstall = [ "info" "man" "share" "icons" "doc" ];

}

