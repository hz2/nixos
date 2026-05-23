# nixos

Personal NixOS configuration for a Hyprland/Wayland desktop on x86_64.

## Structure

```
hosts/jos/        system config (hardware, packages, fonts, services)
home/
  jos.nix         home-manager root
  modules/        per-tool configs (tmux, fish, git, alacritty, hyprland, ...)
```

## Apply

```bash
sudo nixos-rebuild switch --flake ~/nixos#jos
```
