# AGENT.md

This repository contains my personal NixOS dotfiles and system configuration.

The configuration is declarative and managed using Nix. Changes should be made
by editing the configuration files rather than performing manual system
modifications.

Goals:
- Keep the system reproducible
- Keep the configuration simple and readable
- Prefer minimal, explicit configuration over complex abstractions

Assume this repository is the source of truth for my system configuration.
Avoid introducing secrets or machine-specific state unless clearly scoped.