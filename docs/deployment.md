# Deployment Notes

## NixOS host rebuild

```bash
cd ~/linux-dotfiles/nixos-dotfiles
sudo nixos-rebuild switch --flake .#desktop
```

Replace `desktop` with `thinkpad` or `macbook-pro` as needed.

## Home Manager config sources

`nixos-dotfiles/home/quesadx.nix` links selected folders from this repo into `~/.config`.
Current active source:

- `config/active/fastfetch` -> `~/.config/fastfetch`

## Manual linking (optional)

If you want to link files manually without Nix:

```bash
mkdir -p ~/.config ~/.local/bin ~/.local/share/wallpapers
ln -s ~/linux-dotfiles/config/active/fastfetch ~/.config/fastfetch
ln -s ~/linux-dotfiles/local/bin/* ~/.local/bin/
ln -s ~/linux-dotfiles/local/share/wallpapers/* ~/.local/share/wallpapers/
```

## Template usage

Copy a template from `templates/` into your project root as `flake.nix`, then run:

```bash
nix develop
```
