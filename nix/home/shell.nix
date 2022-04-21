{ pkgs, ... }:

with pkgs;

{

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    enableCompletion = true;
    dotDir = ".config/zsh";
    initExtraFirst = builtins.readFile ../../config/zsh/.zshrc;
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];

    shellAliases = {
      ls = "ls --color=auto";
      "cd.." = "cd ..";
      ":q" = "exit";
      ":wq" = "exit";
      wiki = "nvim ~/wiki/index.md";
      vim = "nvim";
      wttr = "curl wttr.in/heidelberg";

      g = "git";
      ga = "git add";
      gap = "git add --patch";
      gc = "git commit";
      gs = "git status";
      gps = "git push";
      gpl = "git pull";

      lsd = "lsd -lah";
    };

    sessionVariables = {
      FZF_DEFAULT_COMMAND = "fd --type f --hidden --follow --exclude .git";
      FZF_CTRL_T_COMMAND = "$FZF_DEFAULT_COMMAND";
      FZF_ALT_C_COMMAND = "fd --type d . $HOME";
    };

    initExtraBeforeCompInit = ''
      [[ -d $HOME/.cache/zsh ]] || mkdir -p $HOME/.cache/zsh
    '';

    completionInit = ''
      autoload -Uz compinit
      compinit -d ~/.cache/zsh/zcompdump-$ZSH_VERSION
      zstyle ':completion:*' menu select
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
      setopt COMPLETE_ALIASES
    '';

    history = {
      path = "$HOME/.cache/zsh/history";
      save = 1000000;
      size = 1200000;
      share = true;
      ignoreDups = true;
    };

    dirHashes = {
      z = "$ZDOTDIR";
      p = "$HOME/Projects";
    };

    initExtra = ''
      # Don't let > overwrite files. To overwrite, use >| instead.
      setopt NO_CLOBBER

      # Allow comments to be pasted into the command line.
      setopt INTERACTIVE_COMMENTS

      # Don't treat non-executable files in your $path as commands.
      setopt HASH_EXECUTABLES_ONLY

      # Enable additional glob operators. (Globbing = pattern matching)
      # https://zsh.sourceforge.io/Doc/Release/Expansion.html#Filename-Generation
      setopt EXTENDED_GLOB

      # Enable ** and *** as shortcuts for **/* and ***, respectively.
      # https://zsh.sourceforge.io/Doc/Release/Expansion.html#Recursive-Globbing
      setopt GLOB_STAR_SHORT

      # Sort numbers numerically, not lexicographically.
      setopt NUMERIC_GLOB_SORT

      # Edit command in vim
      zle -N edit-command-line
      autoload -Uz edit-command-line
      bindkey -M vicmd 'v' edit-command-line

      # Backspace should work as in vim
      bindkey -v '^?' backward-delete-char
      KEYTIMEOUT=1

      function dkfz-vpn-up() {
        echo "Starting the vpn ..."
        sudo openconnect --background --user=t974t gate.dkfz-heidelberg.de
      }

      function dkfz-vpn-down() {
        sudo kill -2 `pgrep openconnect`
      }

      if [ -n "$TMUX" ]; then
        function refresh {
          [[ -n "$(tmux show-environment | grep '^SSH_AUTH_SOCK')" ]] && export "$(tmux show-environment | grep '^SSH_AUTH_SOCK')"
          [[ -n "$(tmux show-environment | grep '^SSH_CLIENT')" ]] && export "$(tmux show-environment | grep '^SSH_CLIENT')"
          [[ -n "$(tmux show-environment | grep '^SSH_CONNECTION')" ]] && export "$(tmux show-environment | grep '^SSH_CONNECTION')"
          [[ -n "$(tmux show-environment | grep '^DISPLAY')" ]] && export "$(tmux show-environment | grep '^DISPLAY')"
        }
      else
        function refresh { }
      fi

      function preexec {
        refresh
      }
    '';

    defaultKeymap = "viins";
  };

  programs.zoxide.enable = true;
  programs.fzf.enable = true;
  programs.direnv = {
    enable = true;
    config = {
      global.load_dotenv = true;
    };
  };

  xdg.configFile."zsh/.p10k.zsh".source = ../../config/zsh/.p10k.zsh;

}
