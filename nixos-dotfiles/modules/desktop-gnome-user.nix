# ─── GNOME DESKTOP CONFIGURATION (User-level) ───────────────────────────
# Home Manager configuration for GNOME Desktop Environment
# Can be replaced with alternative desktop environments (KDE, etc.)

{ config, pkgs, lib, ... }:

{
  # ─── GNOME SETTINGS MANAGEMENT ────────────────────────────────────────────
  dconf.enable = true;

  dconf.settings = {
    # ─── GNOME SHELL EXTENSIONS ───────────────────────────────────────────
    "org/gnome/shell".enabled-extensions = [
      "appindicatorsupport@rgcjonas.gmail.com"  # System tray
      "caffeine@patapon.info"                   # Prevent screen lock
      "luminus-desktop@dikasp.gitlab"           # Status bar tweaks
    ];

    "org/gnome/mutter" = {
      experimental-features = [ "scale-monitor-framebuffer" ];
    };

    # ─── EXTENSION: AppIndicator (System Tray) ────────────────────────────
    "org/gnome/shell/extensions/appindicator".legacy-tray-enabled = false;

    # ─── EXTENSION: Caffeine (Prevent lock) ───────────────────────────────
    "org/gnome/shell/extensions/caffeine" = {
      restore-state = true;
      enable-fullscreen = false;
    };

    # ─── INPUT SOURCES (Keyboard Layouts) ──────────────────────────────────
    "org/gnome/desktop/input-sources" = {
      show-all-sources = true;
      xkb-options = [ "caps:escape" ];  # Caps Lock -> Escape
    };

    # ─── WINDOW MANAGER KEYBINDINGS ───────────────────────────────────────
    "org/gnome/desktop/wm/keybindings" = {
      maximize = [ "<Super>F" ];
      minimize = [ "<Super>D" ];
      close = [ "<Super>Q" ];
      switch-to-workspace-left = [ "<Super>h" ];
      switch-to-workspace-right = [ "<Super>l" ];
    };

    # ─── POWER & SYSTEM SETTINGS ──────────────────────────────────────────
    "org/gnome/settings-daemon/plugins/power".power-button-action = "nothing";

    # ─── MEDIA KEY BINDINGS ───────────────────────────────────────────────
    "org/gnome/settings-daemon/plugins/media-keys" = {
      home = [ "<Super>e" ];
      www = [ "<Super>b" ];
      control-center = [ "<Super>i" ];
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
      ];
    };

    # ─── CUSTOM KEYBINDING: Super+T = Terminal ────────────────────────────
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Super>t";
      command = "kgx";
      name = "gnome-console";
    };

    # ─── MOUSE & ACCESSIBILITY ────────────────────────────────────────────
    "org/gnome/desktop/peripherals/mouse".accel-profile = "flat";
    "org/gnome/desktop/sound".event-sounds = false;
  };
}
