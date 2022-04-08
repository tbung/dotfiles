{ pkgs, ... }:

with pkgs;

{

  programs.git = {
    enable = true;

    userEmail = "tillbungert@gmail.com";
    userName = "Till Bungert";

    extraConfig = {
      core = {
        pager = "less";
        editor = "nvim";
      };
      init = {
        defaultBranch = "main";
      };
      credential = {
        helper = "cache";
      };
      merge = {
        tool = "vimdiff";
      };
      mergetool = {
        keepBackup = false;
      };
      "mergetool \"vimdiff\"" = {
        cmd = "nvim -d $LOCAL $REMOTE $MERGED -c '$wincmd w' -c 'wincmd J'";
      };
    };

    ignores = [
    ];
  };

}

