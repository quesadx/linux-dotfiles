# Placeholder hardware configuration for the ThinkPad X13.
# Replace this file with the generated configuration from the ThinkPad system.
# Example:
#   sudo nixos-generate-config --root /mnt
#   cp /etc/nixos/hardware-configuration.nix /path/to/linux-dotfiles/nixos-dotfiles/hardware-configuration.thinkpad.nix
{ config, lib, pkgs, modulesPath, ... }:
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
}
