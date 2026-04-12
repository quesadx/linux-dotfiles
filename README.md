# dotfiles repo

Minimal configuration files for my Linux setup. Mainly focused on NixOS.

## Environment

- **OS:** NixOS
- **DE:** GNOME (Wayland)
- **Shell:** Zsh / Bash (as fallback)
- **Terminal:** gnome-console (kgx)

## Installation

### Using .config directly

Simply use `stow -t .config` or link with `ln -s`.

### Using NixOS

The NixOS flake is contained in `nixos-dotfiles/`.

Apply the NixOS configuration from that directory:
```bash
cd nixos-dotfiles
sudo nixos-rebuild switch --flake .#hostname
```
