# ============================================================================
# SWAY DESKTOP CONFIGURATION
# ============================================================================
# System-level configuration for Sway Desktop Environment
# Can be replaced with alternative desktop environments (KDE, etc.)

{ config, pkgs, ... }:

{
  # ---------- SWAY DEPENDENCIES ----------
  services.gnome.gnome-keyring.enable = true;
  

  # ---------- SWAY SERVICES ----------
  programs.sway.enable = true;                                               # Sway Window Manager
  programs.sway.wrapperFeatures.gtk = true;                                  # Enable XWayland for legacy app support
  programs.sway.extraPackages = with pkgs; [
    # Sway utilities and tools
    foot                                                                # Wayland terminal emulator
    swayidle                                                            # Idle management (screen locking, etc.)
    swaylock                                                              # Screen locker for Sway
    swaybg                                                                # Set desktop background in Sway
    swaystatus                                                            # Status bar for Sway
    waybar                                                                # Highly customizable status bar for Wayland
    grim                                                                # Screenshot utility for Wayland
    slurp                                                                # Select region for screenshots
  ];


}