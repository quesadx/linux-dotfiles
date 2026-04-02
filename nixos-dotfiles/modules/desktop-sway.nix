# ─── SWAY DESKTOP CONFIGURATION ───────────────────────────────────────────
# System-level configuration for Sway Desktop Environment
# Can be replaced with alternative desktop environments (KDE, etc.)

{ config, pkgs, ... }:

{
  # ─── SWAY DEPENDENCIES ────────────────────────────────────────────────────
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.login.enableGnomeKeyring = true;

  # ─── SWAY SERVICES ────────────────────────────────────────────────────────
  programs.sway.enable = true;
  programs.sway.wrapperFeatures.gtk = true;  # Enable XWayland for legacy apps
  programs.sway.extraPackages = with pkgs; [
    grim   # Screenshot utility for Wayland
    slurp  # Select region for screenshots
  ];

}
