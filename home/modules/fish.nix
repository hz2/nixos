{ ... }:

{
  programs.fish = {
    enable = true;

    shellAliases = {
      cat     = "bat";
      grep    = "rg";
      vim     = "nvim";
      vi      = "nvim";
      clauded = "claude --dangerously-skip-permissions";
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

          set -l gs (git status --porcelain 2>/dev/null)
          if test -n "$gs"
            set -l staged    (string match -r '^[MADRCU]' -- $gs)
            set -l modified  (string match -r '^.[MD]'    -- $gs)
            set -l untracked (string match -r '^\?\?'     -- $gs)
            set -l sc (count $staged)
            set -l mc (count $modified)
            set -l uc (count $untracked)
            echo -n " "
            if test $sc -gt 0
              set_color green
              echo -n "+$sc"
            end
            if test $mc -gt 0
              set_color red
              echo -n "!$mc"
            end
            if test $uc -gt 0
              set_color brblack
              echo -n "?$uc"
            end
          end

          set_color brblack
          echo -n ")"
          set_color normal
        end

        if set -q IN_NIX_SHELL
          set_color cyan
          if set -q name; and test -n "$name"
            echo -n " [nix:$name]"
          else
            echo -n " [nix]"
          end
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
