# ─── GNOME DESKTOP CONFIGURATION ──────────────────────────────────────────
# System-level configuration for GNOME Desktop Environment
# Can be replaced with alternative desktop environments (KDE, etc.)

{ config, pkgs, ... }:

{
  programs.niri.enable = true;

  services.displayManager.gdm.enable = true;
  services.displayManager.defaultSession = "niri";

  # Wayland basics
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
}
