# dotfiles repo

Minimal configuration files for my Linux setup. Mainly focused on NixOS.

## Structure

- `nixos-dotfiles/`: multi-host NixOS + Home Manager configuration.
- `config/active/`: active app config folders (linked into `~/.config` by Home Manager where needed).
- `config/archive/`: archived experimental configs (Sway/Hypr stack).
- `local/`: files intended for `~/.local` (`bin` scripts and `share/wallpapers`).
- `templates/`: reusable `flake.nix` templates for dev environments.
- `wallpapers/`: extra wallpaper assets.

## Environment

- **OS:** NixOS
- **DE:** GNOME (Wayland)
- **Shell:** Zsh / Bash (as fallback)
- **Terminal:** gnome-console (kgx)

## Installation

### Using config and local folders directly

Link the folders you want into your home directory, for example:

```bash
ln -s ~/linux-dotfiles/config/active/fastfetch ~/.config/fastfetch
ln -s ~/linux-dotfiles/local/bin/* ~/.local/bin/
```

### Using NixOS

The NixOS flake is contained in `nixos-dotfiles/`.

Apply the NixOS configuration from that directory:
```bash
cd nixos-dotfiles
sudo nixos-rebuild switch --flake .#hostname
```
