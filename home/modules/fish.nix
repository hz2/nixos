{ ... }:

{
  programs.fish = {
    enable = true;

    shellAliases = {
      cat  = "bat";
      grep = "rg";
      vim  = "nvim";
      vi   = "nvim";
    };

    shellAbbrs = {
      g   = "git";
      gs  = "git status";
      gd  = "git diff";
      ga  = "git add";
      gc  = "git commit";
      gp  = "git push";
      gl  = "git log --oneline --graph";
      gco = "git checkout";
      gbr = "git branch";
      t   = "tmux";
      ta  = "tmux attach";
      tn  = "tmux new -s";
      tl  = "tmux ls";
    };

    shellInit = ''
      fish_add_path ~/.local/bin ~/.cargo/bin ~/go/bin
    '';

    interactiveShellInit = ''
      set fish_greeting ""
      zoxide init fish | source
      fzf --fish | source
    '';

    functions.fish_prompt = {
      body = ''
        set -l last_status $status
        set -l cwd (prompt_pwd)

        set_color blue
        echo -n $cwd
        set_color normal

        set -l branch (git branch --show-current 2>/dev/null)
        if test -n "$branch"
          set_color brblack
          echo -n " ("
          set_color yellow
          echo -n $branch
          set_color brblack
          echo -n ")"
          set_color normal
        end

        echo -n " "
        if test $last_status -eq 0
          set_color green
        else
          set_color red
        end
        echo -n "λ"
        set_color normal
        echo -n " "
      '';
    };
  };
}
