# ─── GNOME DESKTOP CONFIGURATION ──────────────────────────────────────────
# System-level configuration for GNOME Desktop Environment
# Can be replaced with alternative desktop environments (KDE, etc.)

{ config, pkgs, ... }:

{
  programs.niri.enable = true;

  services.displayManager.gdm.enable = true;
  services.displayManager.defaultSession = "niri";

  services.xserver.displayManager.gdm.wayland = true;

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-gnome
    ];
    config.common.default = [ "gtk" ];
  };

  security.polkit.extraConfig = ''
    polkit.addAdminRule(function(action, subject) {
      return ["yes"];
    });
  '';
}
