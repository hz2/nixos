{ pkgs, ... }:

let
  git-status = pkgs.writeShellScript "tmux-git-status" ''
    if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
      branch=$(git branch --show-current 2>/dev/null)
      git_status=$(git status --porcelain 2>/dev/null)

      modified=$(echo "$git_status" | grep -c "^ M" || true)
      staged=$(echo "$git_status"   | grep -c "^M"  || true)
      untracked=$(echo "$git_status"| grep -c "^??" || true)

      output=" $branch"

      if [ -n "$git_status" ]; then
        status_parts=""
        [ "$modified"  -gt 0 ] && status_parts="''${status_parts}~''${modified}"
        [ "$staged"    -gt 0 ] && status_parts="''${status_parts}+''${staged}"
        [ "$untracked" -gt 0 ] && status_parts="''${status_parts}?''${untracked}"
        [ -n "$status_parts" ] && output="''${output} [''${status_parts}]"
      fi

      echo "$output"
    fi
  '';

  network-status = pkgs.writeShellScript "tmux-network-status" ''
    interface=$(ip route 2>/dev/null | grep "^default" | awk '{print $5}' | head -n1)
    if [ -z "$interface" ]; then echo "N/A"; exit 0; fi

    rx_file="/sys/class/net/$interface/statistics/rx_bytes"
    tx_file="/sys/class/net/$interface/statistics/tx_bytes"
    [ -f "$rx_file" ] || exit 0

    rx_bytes=$(cat "$rx_file")
    tx_bytes=$(cat "$tx_file")
    tmp_file="/tmp/tmux-network-''${interface}.tmp"
    current_time=$(date +%s)

    if [ -f "$tmp_file" ]; then
      read -r prev_rx prev_tx prev_time < "$tmp_file"
      time_diff=$((current_time - prev_time))

      if [ "$time_diff" -gt 0 ]; then
        rx_diff=$(( (rx_bytes - prev_rx) / time_diff ))
        tx_diff=$(( (tx_bytes - prev_tx) / time_diff ))

        fmt() {
          local b=$1
          if   [ "$b" -lt 1024    ]; then echo "''${b}B/s"
          elif [ "$b" -lt 1048576 ]; then echo "$((b / 1024))KB/s"
          else echo "$((b / 1048576))MB/s"
          fi
        }

        echo "↓ $(fmt "$rx_diff") ↑ $(fmt "$tx_diff")"
      else
        echo "↓ -- ↑ --"
      fi
    else
      echo "↓ -- ↑ --"
    fi

    echo "$rx_bytes $tx_bytes $current_time" > "$tmp_file"
  '';

  nix-status = pkgs.writeShellScript "tmux-nix-status" ''
    if [ -n "$IN_NIX_SHELL" ]; then
      if [ -n "$name" ]; then
        echo "● $name"
      else
        echo "● nix"
      fi
    fi
  '';

  notify-status = pkgs.writeShellScript "tmux-notify-status" ''
    notif_file="$HOME/.local/state/notifications.tsv"
    if [ ! -f "$notif_file" ] || [ ! -s "$notif_file" ]; then exit 0; fi

    count=$(wc -l < "$notif_file")
    latest=$(tail -1 "$notif_file" | cut -f3 | cut -c1-40)

    if [ "$count" -eq 1 ]; then
      echo "#[fg=colour196,bold]▲ ''${latest}#[default] "
    else
      echo "#[fg=colour196,bold]▲ ''${count} alerts#[default] "
    fi
  '';

  system-resources = pkgs.writeShellScript "tmux-system-resources" ''
    load=$(uptime | awk -F'load average:' '{print $2}' | awk '{print $1}' | sed 's/,//')
    mem=$(free -h | awk '/Mem:/ {printf "%s/%s", $3, $2}')
    echo " ''${load} ● ''${mem}"
  '';

  time-display = pkgs.writeShellScript "tmux-time-display" ''
    pdt=$(TZ="America/Los_Angeles" date "+%H:%M")
    utc=$(date -u "+%H:%M")
    ip=$(ip -4 route get 1.1.1.1 2>/dev/null | awk '{print $7; exit}')
    echo "''${pdt} PDT | ''${utc} UTC | ''${ip:-N/A}"
  '';

in
{
  programs.tmux = {
    enable       = true;
    prefix       = "C-a";
    mouse        = true;
    baseIndex    = 1;
    escapeTime   = 0;
    historyLimit = 50000;
    keyMode      = "vi";
    terminal     = "tmux-256color";

    extraConfig = ''
      set -ag terminal-overrides ",alacritty:RGB"

      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      unbind '"'
      unbind %

      bind c new-window -c "#{pane_current_path}"

      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      bind -r H resize-pane -L 5
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r L resize-pane -R 5

      bind r source-file ~/.config/tmux/tmux.conf \; display "Reloaded"

      set -g renumber-windows on

      # Status bar — bottom, nordfox palette
      set -g status-position  bottom
      set -g status-interval  5
      set -g status-style     "bg=#2e3440,fg=#cdcecf"

      set -g status-left        "#[bg=#81a1c1,fg=#2e3440,bold] #S #[bg=#2e3440,fg=#81a1c1] "
      set -g status-left-length 30

      set -g status-right        "#(${nix-status})#[fg=#4c566a]│ #[fg=#a3be8c]#(${git-status}) #[fg=#4c566a]│ #[fg=#cdcecf]#(${network-status}) #[fg=#4c566a]│ #[fg=#cdcecf]#(${system-resources}) #[fg=#4c566a]│ #[fg=#88c0d0]#(${notify-status})#[fg=#cdcecf]#(${time-display})"
      set -g status-right-length 200

      set -g window-status-format         "#[fg=#4c566a] #I:#W "
      set -g window-status-current-format "#[bg=#3b4252,fg=#cdcecf,bold] #I:#W "

      set -g pane-border-style        "fg=#3b4252"
      set -g pane-active-border-style "fg=#81a1c1"
      set -g message-style            "bg=#3b4252,fg=#cdcecf"

      bind -T copy-mode-vi v               send-keys -X begin-selection
      bind -T copy-mode-vi y               send-keys -X copy-pipe-and-cancel "wl-copy"
      bind -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "wl-copy"
    '';
  };
}
