{ config, pkgs, ... }:

with pkgs;

{
  imports = [
    ./shell.nix
    ./kitty.nix
    ./git.nix
    ./tmux.nix
  ];

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

    rclone

    gh
    glab

    neovim-nightly
    sumneko-lua-language-server
    nodePackages.pyright
    nodePackages.prettier
    nodePackages.vscode-langservers-extracted
    black
    stylua
    ccls
    rnix-lsp
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

    jq
    pandoc

    zsh-powerlevel10k
    zsh-autosuggestions
    zsh-syntax-highlighting
    fzf
    zk

    (weechat.override
      {
        configure = { availablePlugins, ... }: {
          scripts = with pkgs.weechatScripts;
            [ weechat-matrix ];
        };
      })
  ];


  home.sessionVariables = {
    XDG_CONFIG_HOME = "$HOME/.config";
    BROWSER = "brave";
    TERMINAL = "kitty";

    EDITOR = "${pkgs.neovim-nightly}/nvim";
    VISUAL = "${pkgs.neovim-nightly}/nvim";
    GITLAB_HOST = "gitlab.hzdr.de";
    ZK_NOTEBOOK_DIR = "$HOME/wiki";
  };

  home.sessionPath = [
    "$HOME/.local/bin"
  ];
  home.file.".local/bin".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Projects/dotfiles/local/bin";

  xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Projects/dotfiles/config/nvim";

  # https://github.com/rycee/home-manager/issues/432
  home.extraOutputsToInstall = [ "info" "man" "share" "icons" "doc" ];

}
