# AGENT.md

This repository contains my personal NixOS configuration (flake-based) and home manager profiles.

Root files:
- `flake.nix` (system + home flake outputs)
- `configuration.nix` (top-level host configuration)
- `hardware-configuration.nix`
- `home/quesadx.nix` (home-manager settings)
- `modules/desktop-gnome.nix`, `modules/desktop-gnome-user.nix`

Workflow:
1. Treat this repository as single source of truth for system state.
2. Implement changes by editing Nix files, then rebuild with `sudo nixos-rebuild switch --flake .#<hostname>` (or `home-manager switch` for user bits) in this repo path.
3. Do not suggest manual imperative changes (e.g., `apt install`, `pip install --user`, direct `/etc` edits) unless there is a clear temporary troubleshooting note and the permanent fix is in Nix.

Agent-level constraints:
- Prefer explicit Nix expressions and minimal dependencies.
- Keep config consistent with existing style (simple attribute sets, avoid complex `mkIf`/`lib.concatMap` unless needed).
- Avoid exposing secrets; if a secret is required, reference a stable secret-management fallback (e.g. `builtins.readFile ../secrets/whatever` pattern) and note `not committed`.
- For commands, use `nix flake show`, `nixos-rebuild`, `home-manager`, `nix build` semantics.

Assume the system target is NixOS with GNOME desktop as configured in this repo.
Use the repository structure and option names already present.

Goals:
- Keep the system reproducible and declarative.
- Keep the configuration simple, readable and aligned with existing file organization.
- Prefer minimal explicit configuration over complex abstraction layers.

No secrets or machine-specific ephemeral state in repo content unless scoped to local inclusion files not tracked.