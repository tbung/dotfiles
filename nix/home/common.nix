{ config, pkgs, ... }:

with pkgs;

{
  imports = [
    ./shell.nix
    ./kitty.nix
    ./git.nix
    ./tmux.nix
  ];

  home.stateVersion = "22.05";

  programs.home-manager.enable = true;

  home.packages = [
    tmux
    htop
    rsync
    coreutils-full

    git
    git-lfs

    (python310.withPackages (pypkgs: with pypkgs; [
      pynvim
      ipython
    ]))
    nodejs
    gcc

    rclone

    gh
    glab

    neovim-nightly
    sumneko-lua-language-server
    nodePackages.pyright
    nodePackages.prettier
    nodePackages.vscode-langservers-extracted
    nodePackages.bash-language-server
    stylua
    ccls
    rnix-lsp
    shfmt
    proselint
    texlive.combined.scheme-full

    (nerdfonts.override { fonts = [ "VictorMono" ]; })

    # modern unix tools
    ripgrep
    fd
    mdcat
    lsd
    zoxide
    delta
    bat

    jq
    pandoc
    ffmpeg-full

    zsh-powerlevel10k
    zsh-autosuggestions
    zsh-syntax-highlighting
    fzf
    zk

    # (weechat.override
    #   {
    #     configure = { availablePlugins, ... }: {
    #       scripts = with pkgs.weechatScripts;
    #         [ weechat-matrix ];
    #     };
    #   })
  ];


  home.sessionVariables = {
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_CACHE_HOME = "$HOME/.cache";
    BROWSER = "brave";
    TERMINAL = "kitty";

    # EDITOR = "${pkgs.neovim-nightly}/bin/nvim";
    # VISUAL = "${pkgs.neovim-nightly}/bin/nvim";
    GITLAB_HOST = "gitlab.hzdr.de";
    ZK_NOTEBOOK_DIR = "$HOME/wiki";

    MANPAGER="nvim +Man!";
  };

  home.sessionPath = [
    "$HOME/.local/bin"
  ];
  home.file.".local/bin".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Projects/dotfiles/local/bin";

  xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Projects/dotfiles/config/nvim";

  # https://github.com/rycee/home-manager/issues/432
  home.extraOutputsToInstall = [ "info" "man" "share" "icons" "doc" ];

}
