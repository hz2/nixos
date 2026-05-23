{ pkgs, ... }:

{
  imports = [
    ./modules/alacritty.nix
    ./modules/tmux.nix
    ./modules/fish.nix
    ./modules/git.nix
    ./modules/direnv.nix
    ./modules/ssh.nix
    ./modules/dev.nix
    ./modules/hyprland.nix
    ./modules/cli-tools.nix
  ];

  home.username    = "jos";
  home.homeDirectory = "/home/jos";
  home.stateVersion  = "24.11";

  home.packages = with pkgs; [
    neovim
    lazygit
    xdg-utils
    zoxide
  ];

  home.sessionVariables = {
    EDITOR  = "nvim";
    BROWSER = "firefox";
    TERM    = "alacritty";
  };

  programs.home-manager.enable = true;
}
