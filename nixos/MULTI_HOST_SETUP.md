# Multi-Host NixOS Configuration

This setup now supports managing multiple NixOS machines from a single dotfiles repository.

## Current Architecture

### New Files

- **`hosts.nix`**: Central host registry mapping each machine to its hostname, hardware config, and nixos-hardware modules
- **`hardware-configuration.desktop.nix`**: Generated hardware config for i5-9400 desktop
- **`hardware-configuration.thinkpad.nix`**: Placeholder for ThinkPad X13 Gen 2 hardware config

### Updated Files

- **`flake.nix`**: Now generates multiple `nixosConfigurations` outputs (one per host) instead of a single hardcoded config
- **`configuration.nix`**: Receives `host` parameter; uses `host.hostname` instead of `shared.hostname`
- **`home/quesadx.nix`**: Receives `host` parameter; rebuild aliases now dynamically target the current host
- **`agent.md`**: Updated file map to reflect new structure

### Removed

- Single `hardware-configuration.nix` → split into per-host files

## Available Hosts

```
desktop     (i5-9400 desktop, Intel CPU)
thinkpad    (ThinkPad X13 Gen 2, Intel CPU)
```

## How to Use

### On Desktop (current)

```bash
# Test configuration (dry-run)
sudo nixos-rebuild test --flake .#desktop

# Apply configuration
sudo nixos-rebuild switch --flake .#desktop

# Or use the alias (automatically targets desktop):
nrs
```

### On ThinkPad X13

Generate the hardware config on the ThinkPad:

```bash
sudo nixos-generate-config --root /mnt
# Copy to your dotfiles repo:
cp /mnt/etc/nixos/hardware-configuration.nix \
   ~/linux-dotfiles/nixos-dotfiles/hardware-configuration.thinkpad.nix
# Commit and push
git add hardware-configuration.thinkpad.nix && git commit -m "Add ThinkPad hardware config"
```

Then rebuild:

```bash
sudo nixos-rebuild switch --flake .#thinkpad
nrs  # uses alias; automatically targets thinkpad
```

## Adding a New Host

1. Add entry to `hosts.nix`:

   ```nix
   my-machine = {
     hostname = "my-machine";
     hardwareConfig = ./hardware-configuration.my-machine.nix;
     hardwareModules = [];  # add nixos-hardware modules if needed
   };
   ```

2. Create `hardware-configuration.my-machine.nix`:

   ```bash
   # Run on the target machine
   sudo nixos-generate-config --root /mnt
   cp /mnt/etc/nixos/hardware-configuration.nix ~/linux-dotfiles/nixos-dotfiles/hardware-configuration.my-machine.nix
   ```

3. Commit and use:

   ```bash
   git add hosts.nix hardware-configuration.my-machine.nix
   sudo nixos-rebuild switch --flake .#my-machine
   ```

## Host-Specific Configuration

All three machines share:
- User configuration (`home/quesadx.nix`)
- System packages and services (`configuration.nix`)
- GNOME desktop setup (`modules/desktop-gnome.nix`)
- Locale, timezone, and user groups

Per-host differences are **hardware config only**. To add host-specific system settings in the future:

- Create `modules/system-<hostname>.nix` and conditionally import in `configuration.nix` based on `host.hostname`
- Create `modules/home-<hostname>.nix` and conditionally import in `home/quesadx.nix` based on `host.hostname`

## Hardware Module Support

The ThinkPad config automatically includes `nixos-hardware.nixosModules.lenovo-thinkpad-x13-intel` via `hosts.nix`. The desktop doesn't import any nixos-hardware modules (add if needed in `hosts.nix`).

To find modules for your systems:

```bash
nix flake show github:NixOS/nixos-hardware
```

## Verify Setup

```bash
# Show all available configurations
nix flake show

# Expected output:
# └───nixosConfigurations
#     ├───desktop: NixOS configuration
#     └───thinkpad: NixOS configuration

# Dry-run build test
nix build .#nixosConfigurations.desktop.config.system.build.toplevel --dry-run
```
