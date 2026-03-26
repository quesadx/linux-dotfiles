# ============================================================================
# GNOME DESKTOP CONFIGURATION
# ============================================================================
# System-level configuration for GNOME Desktop Environment
# Can be replaced with alternative desktop environments (KDE, etc.)

{ config, pkgs, ... }:

{
  # ---------- GNOME SERVICES ----------
  services.displayManager.gdm.enable = true;     # GNOME Display Manager
  services.desktopManager.gnome.enable = true;   # GNOME Desktop
  services.gnome.core-apps.enable = false;       # Minimal GNOME (no bloat)
  services.gnome.core-developer-tools.enable = false;
  services.gnome.games.enable = false;

  # ---------- GNOME EXTENSIONS ----------
  environment.systemPackages = with pkgs.gnomeExtensions; [
    alphabetical-app-grid     # Alphabetical app drawer
    auto-accent-colour        # Dynamic accent color
    caffeine                  # Prevent screen lock
    clipboard-history         # Clipboard manager
    luminus-desktop           # Status bar enhancements
    top-bar-organizer         # Customize GNOME top bar
    appindicator              # Legacy system tray support
    screen-vibrancy-saturation-extension
  ];

  # ---------- GNOME EXCLUSIONS ----------
  environment.gnome.excludePackages = with pkgs; [
    gnome-tour         # Skip GNOME welcome tour
    gnome-user-docs    # Exclude offline documentation
  ];
}
