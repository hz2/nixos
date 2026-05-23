{ pkgs, ... }:

{
  programs.git = {
    enable    = true;
    lfs.enable = true;

    settings = {
      user = {
        name  = "jos";
        email = "jsondevers@gmail.com";
      };

      init.defaultBranch = "main";
      pull.rebase        = true;

      http.postBuffer = 524288000; # 500 MB

      core = {
        editor   = "nvim";
        autocrlf = "input";
        safecrlf = true;
        pager    = "delta";
      };

      help.autocorrect = 1;

      diff = {
        algorithm          = "patience";
        compactionHeuristic = true;
        colorMoved         = "default";
      };

      merge = {
        conflictstyle = "diff3";
        tool          = "nvim";
      };

      mergetool.nvim.cmd = "nvim -d";

      color.ui = true;

      interactive.diffFilter = "delta --color-only";

      alias = {
        c    = "commit";
        s    = "status";
        lg   = "log --oneline";
        last = "log --graph --decorate --oneline --pretty";
        f    = "push --force-with-lease";
        sl   = "stash list";
      };
    };

    ignores = [ ".direnv" ".DS_Store" "*.swp" "*.swo" ".envrc" ];
  };

  home.packages = [ pkgs.delta ];
}
