# Repository Structure

## Main directories

- `nixos-dotfiles/`: system source of truth for NixOS and Home Manager.
- `config/active/`: app configs currently considered active.
- `config/archive/`: archived alternative/experimental app configs.
- `local/bin/`: user scripts intended for `~/.local/bin`.
- `local/share/wallpapers/`: wallpapers intended for `~/.local/share/wallpapers`.
- `templates/`: reusable development flake templates by language/stack.
- `wallpapers/`: extra wallpaper assets not tied to the local deployment path.

## Nix flow (high level)

1. `nixos-dotfiles/flake.nix` reads host definitions from `nixos-dotfiles/hosts.nix`.
2. For each host, flake outputs `nixosConfigurations.<host-key>`.
3. Each host loads:
   - `nixos-dotfiles/configuration.nix`
   - host hardware config (`hardware-configuration.*.nix`)
   - host hardware modules from `nixos-hardware`
   - Home Manager user module (`nixos-dotfiles/home/quesadx.nix`)
4. Home Manager links user config sources such as `config/active/fastfetch` into `~/.config`.

## Host targets

Use the keys from `nixos-dotfiles/hosts.nix` as flake targets:

- `desktop`
- `thinkpad`
- `macbook-pro`
