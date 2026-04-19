# AGENT.md

## Quick Context
- Repo type: personal flake-based NixOS + Home Manager dotfiles.
- **Multi-host setup**: Supports desktop and thinkpad from same repo.
- Desktop target: GNOME.
- Source of truth: this repo only.
- See `MULTI_HOST_SETUP.md` for detailed usage instructions.

## High-Signal File Map
- `flake.nix`: flake inputs/outputs, host wiring.
- `configuration.nix`: system-level host config.
- `home/quesadx.nix`: user-level Home Manager config.
- `hosts.nix`: per-host names, hardware config paths, and host-specific modules.
- `modules/system/desktop-gnome.nix`: GNOME system module.
- `modules/home/desktop-gnome-user.nix`: GNOME user module.
- `modules/hosts/host-macbook-pro.nix`: MacBook Pro host-specific overrides.
- `hardware/hardware-configuration.desktop.nix`: desktop hardware configuration.
- `hardware/hardware-configuration.thinkpad.nix`: ThinkPad hardware configuration.

## Non-Negotiables
- Keep everything declarative and reproducible.
- Prefer editing existing Nix files over introducing new abstraction.
- Keep style simple: explicit attrsets, minimal indirection.
- Do not add secrets or machine-ephemeral state to tracked files.
- Do not propose imperative system drift (`apt`, manual `/etc` edits, etc.) as final solution.

## Preferred Change Style
- Small, explicit diffs.
- Reuse existing option names and structure.
- Avoid complex `lib` patterns unless clearly necessary.
- If a secret is required, reference a non-committed file pattern (for example `builtins.readFile ../secrets/<name>`), and state it is not committed.

## Commands To Use
- Inspect/evaluate: `nix flake show`, `nix build`.
- Apply system changes: `sudo nixos-rebuild switch --flake .#<hostname>`.
- Apply user-only changes: `home-manager switch`.

## Agent Execution Checklist
1. Read the relevant file(s) first; preserve existing structure.
2. Implement the smallest correct declarative change.
3. Validate with `nix flake show` (or relevant build command).
4. Report what changed and why, briefly.

## Goal Priority
1. Correctness and reproducibility.
2. Readability and maintainability.
3. Minimal complexity.