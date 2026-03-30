# ============================================================================
# GNOME DESKTOP CONFIGURATION (User-level)
# ============================================================================
# Home Manager configuration for GNOME Desktop Environment
# Can be replaced with alternative desktop environments (KDE, etc.)

{ config, pkgs, lib, ... }:

{
  # ---------- GNOME CONFIGURATION ----------
  dconf.enable = true;                                                  # GNOME settings (dconf) management

  dconf.settings = {
    # GNOME Shell extensions
    "org/gnome/shell".enabled-extensions = [
      "AlphabeticalAppGrid@stuarthayhurst"                              # Alphabetical app grid
      "appindicatorsupport@rgcjonas.gmail.com"                          # System tray
      "auto-accent-colour@Wartybix"                                     # Dynamic accent colors
      "caffeine@patapon.info"                                           # Prevent screen lock
      "clipboard-history@alexsaveau.dev"                                # Clipboard history
      "luminus-desktop@dikasp.gitlab"                                   # Status bar tweaks
      "top-bar-organizer@julian.gse.jsts.xyz"                           # Customize top bar
    ];

    # Extension: Alphabetical App Grid
    "org/gnome/shell/extensions/alphabetical-app-grid".folder-order-position = "start";

    # Extension: AppIndicator (System Tray)
    "org/gnome/shell/extensions/appindicator".legacy-tray-enabled = false;

    # Extension: Caffeine (Prevent lock)
    "org/gnome/shell/extensions/caffeine" = {
      restore-state = true;                                             # Restore after sleep
      enable-fullscreen = false;                                        # Off in fullscreen
    };

    # Input method settings
    "org/gnome/desktop/input-sources" = {
      show-all-sources = true;                                          # Show all keyboard layouts
      sources = [
        (lib.gvariant.mkTuple [
          "xkb"                                                         # Keyboard type
          "us+altgr-intl"                                               # US layout with AltGr international characters
        ])
      ];
      xkb-options = [ "caps:escape" ];                                  # Caps Lock -> Escape
    };

    # Window manager keybindings (Super = Windows key)
    "org/gnome/desktop/wm/keybindings" = {
      maximize = [ "<Super>F" ];                                        # Super+F to maximize
      minimize = [ "<Super>D" ];                                        # Super+D to minimize
      close = [ "<Super>Q" ];                                           # Super+Q to close
      switch-to-workspace-left = [ "<Super>h" ];                        # Super+H to move workspace left
      switch-to-workspace-right = [ "<Super>l" ];                       # Super+L to move workspace right
    };

    # Power & system settings
    "org/gnome/settings-daemon/plugins/power".power-button-action = "nothing"; # Power button does nothing

    # Media key bindings (for folder/browser/settings access)
    "org/gnome/settings-daemon/plugins/media-keys" = {
      home = [ "<Super>e" ];                                            # Super+E = File manager
      www = [ "<Super>b" ];                                             # Super+B = Browser
      control-center = [ "<Super>i" ];                                  # Super+I = Settings
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
      ];
    };

    # custom0: Super+T = Launch Terminal
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Super>t";
      command = "kgx";
      name = "gnome-console";
    };

    # Mouse & accessibility
    "org/gnome/desktop/peripherals/mouse".accel-profile = "flat";       # No mouse acceleration
    "org/gnome/desktop/sound".event-sounds = false;                     # Disable system sounds
  };
}
