# ============================================================================
# GNOME DESKTOP CONFIGURATION (User-level)
# ============================================================================
# Home Manager configuration for GNOME Desktop Environment
# Can be replaced with alternative desktop environments (KDE, etc.)

{ config, pkgs, lib, ... }:

{
  # ---------- GNOME CONFIGURATION ----------
  dconf.enable = true; # GNOME settings (dconf) management

  # GNOME Shell extensions
  dconf.settings."org/gnome/shell".enabled-extensions = [
    "AlphabeticalAppGrid@stuarthayhurst" # Alphabetical app grid
    "appindicatorsupport@rgcjonas.gmail.com" # System tray
    "auto-accent-colour@Wartybix" # Dynamic accent colors
    "caffeine@patapon.info" # Prevent screen lock
    "clipboard-history@alexsaveau.dev" # Clipboard history
    "luminus-desktop@dikasp.gitlab" # Status bar tweaks
    "top-bar-organizer@julian.gse.jsts.xyz" # Customize top bar
  ];

  # Extension: Alphabetical App Grid
  dconf.settings."org/gnome/shell/extensions/alphabetical-app-grid".folder-order-position = "start";

  # Extension: AppIndicator (System Tray)
  dconf.settings."org/gnome/shell/extensions/appindicator".legacy-tray-enabled = false;

  # Extension: Caffeine (Prevent lock)
  dconf.settings."org/gnome/shell/extensions/caffeine".restore-state = true; # Restore after sleep
  dconf.settings."org/gnome/shell/extensions/caffeine".enable-fullscreen = false; # Off in fullscreen

  # Input method settings
  dconf.settings."org/gnome/desktop/input-sources".show-all-sources = true; # Show all keyboard layouts
  dconf.settings."org/gnome/desktop/input-sources".sources = [
    (lib.gvariant.mkTuple [
      "xkb" # Keyboard type
      "us+altgr-intl" # US layout with AltGr international characters
    ])
  ];

  # CAPS Lock to Escape
  dconf.settings."org/gnome/desktop/input-sources".xkb-options = [ "caps:escape" ]; # Caps Lock -> Escape

  # Window manager keybindings (Super = Windows key)
  dconf.settings."org/gnome/desktop/wm/keybindings".maximize = [ "<Super>F" ]; # Super+F to maximize
  dconf.settings."org/gnome/desktop/wm/keybindings".minimize = [ "<Super>D" ]; # Super+D to minimize
  dconf.settings."org/gnome/desktop/wm/keybindings".close = [ "<Super>Q" ]; # Super+Q to close

  # Power & system settings
  dconf.settings."org/gnome/settings-daemon/plugins/power".power-button-action = "nothing"; # Power button does nothing

  # Media key bindings (for folder/browser/settings access)
  dconf.settings."org/gnome/settings-daemon/plugins/media-keys".home = [ "<Super>e" ]; # Super+E = File manager
  dconf.settings."org/gnome/settings-daemon/plugins/media-keys".www = [ "<Super>b" ]; # Super+B = Browser
  dconf.settings."org/gnome/settings-daemon/plugins/media-keys".control-center = [ "<Super>i" ]; # Super+I = Settings

  # Custom media keybinding (terminal launcher)
  dconf.settings."org/gnome/settings-daemon/plugins/media-keys".custom-keybindings = [
    "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
  ];

  # custom0: Super+T = Launch Terminal
  dconf.settings."org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0".binding =
    "<Super>t";
  dconf.settings."org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0".command =
    "kgx";
  dconf.settings."org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0".name =
    "gnome-console";

  # Mouse & accessibility
  dconf.settings."org/gnome/desktop/peripherals/mouse".accel-profile = "flat"; # No mouse acceleration
  dconf.settings."org/gnome/desktop/sound".event-sounds = false; # Disable system sounds
}
