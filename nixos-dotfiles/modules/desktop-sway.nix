# ─── SWAY DESKTOP CONFIGURATION ───────────────────────────────────────────
# System-level configuration for Sway Desktop Environment
# Can be replaced with alternative desktop environments (KDE, etc.)

{ config, pkgs, ... }:

{
  # ─── SWAY SERVICES ────────────────────────────────────────────────────────
  programs.sway.enable = true;
  # wayland.windowManager.sway.systemd.variables = [ "--all" ];
  programs.sway.wrapperFeatures.gtk = true; # Enable XWayland for legacy apps

}
