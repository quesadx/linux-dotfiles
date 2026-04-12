# ─── GNOME DESKTOP CONFIGURATION ──────────────────────────────────────────
# System-level configuration for GNOME Desktop Environment
# Can be replaced with alternative desktop environments (KDE, etc.)

{ config, pkgs, ... }:

{
  # ─── GNOME SERVICES ───────────────────────────────────────────────────────
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  services.gnome.core-apps.enable = false;
  services.gnome.core-developer-tools.enable = false;
  services.gnome.games.enable = false;

  # ─── GNOME EXTENSIONS ─────────────────────────────────────────────────────
  environment.systemPackages = with pkgs.gnomeExtensions; [
    alphabetical-app-grid              # Alphabetical app drawer
    caffeine                           # Prevent screen lock
    clipboard-history                  # Clipboard manager
    luminus-desktop                    # Status bar enhancements
    appindicator                       # Legacy system tray support
  ];

  # ─── GNOME EXCLUSIONS ─────────────────────────────────────────────────────
  environment.gnome.excludePackages = with pkgs; [
    gnome-tour       # Skip GNOME welcome tour
    gnome-user-docs  # Exclude offline documentation
  ];
}
