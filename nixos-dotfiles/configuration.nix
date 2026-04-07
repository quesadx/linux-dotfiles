{
  config,
  pkgs,
  shared,
  ...
}:

# ============================================================================
# VARIABLES - Centralized configuration values for easy maintenance
# ============================================================================

let
  inherit (shared)
    username
    userDescription
    hostname
    timeZone
    locale
    regionalLocale
    ;

  # ─── USER GROUPS ──────────────────────────────────────────────────────────
  userGroups = [
    "networkmanager" # Networking
    "wheel" # Sudo access
    "video"
    "render" # GPU access
    "audio" # Audio access
    "docker"
    "kvm" # Virtualization
  ];

  # ─── CORE PACKAGES ────────────────────────────────────────────────────────
  corePackages = with pkgs; [
    vim
    wget
    curl # CLI tools
    steam-run # VM management and Steam runtime
    tldr # Community-driven man pages
    wdisplays # Display configuration utility for Wayland (GUI)
    brightnessctl # Display backlight control utility
    bluetuith # Bluetooth TUI
  ];

  # ─── SYSTEM FONTS ────────────────────────────────────────────────────────
  systemFonts = with pkgs; [
    ibm-plex # Professional sans-serif
    noto-fonts
    noto-fonts-color-emoji # Unicode coverage
    font-awesome # Icon font
    nerd-fonts.jetbrains-mono # Monospace with ligatures
  ];

in

# ─── SYSTEM CONFIGURATION ────────────────────────────────────────────────

{
  imports = [
    ./hardware-configuration.nix
    ./modules/desktop-sway.nix
  ];

  # ─── BOOT & KERNEL ────────────────────────────────────────────────────────
  boot.kernelPackages = pkgs.linuxPackages_zen;

  boot.kernelParams = [
    "i915.enable_psr=1" # Panel Self Refresh — big battery win on Intel iGPU
    "i915.enable_fbc=1" # Framebuffer compression
    "i915.enable_dc=1" # Deep power states for display engine (try 2, fallback to 1 if issues)
    "nvme.noacpi=1" # If you have NVMe — prevents ACPI conflicts
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.timeout = 0; # skip menu entirely, boot immediately
  boot.loader.efi.canTouchEfiVariables = true;

  # ─── MEMORY & SWAP ────────────────────────────────────────────────────────
  zramSwap.enable = true;
  zramSwap.memoryPercent = 75;
  zramSwap.algorithm = "lz4";
  systemd.oomd.enable = true;

  # ─── NETWORKING ───────────────────────────────────────────────────────────
  networking = {
    hostName = hostname;
    networkmanager.enable = true;
  };

  systemd.services.NetworkManager-wait-online.enable = false;

  # Firewall configuration
  networking.firewall.enable = true;
  networking.firewall.trustedInterfaces = [ "virbr0" ]; # KVM bridge
  networking.firewall.allowedTCPPorts = [ 24800 ]; # Synergy port

  # ─── USERS & GROUPS ───────────────────────────────────────────────────────
  users.users.${username} = {
    isNormalUser = true;
    description = userDescription;
    extraGroups = userGroups;
  };

  # ─── LOCALIZATION ────────────────────────────────────────────────────────
  time.timeZone = timeZone;

  i18n = {
    defaultLocale = locale;
    extraLocaleSettings = {
      LC_ADDRESS = regionalLocale;
      LC_IDENTIFICATION = regionalLocale;
      LC_MEASUREMENT = regionalLocale;
      LC_MONETARY = regionalLocale;
      LC_NAME = regionalLocale;
      LC_NUMERIC = regionalLocale;
      LC_PAPER = regionalLocale;
      LC_TELEPHONE = regionalLocale;
      LC_TIME = regionalLocale;
    };
  };

  # ─── HARDWARE ─────────────────────────────────────────────────────────────
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  hardware.graphics.enable = true;

  # ─── VIRTUALIZATION ───────────────────────────────────────────────────────
  virtualisation.docker.enable = true;
  virtualisation.docker.daemon.settings = {
    bip = "192.168.30.1/24";
    "default-address-pools" = [
      {
        base = "10.10.0.0/16";
        size = 24;
      }
    ];
  };

  # ─── SECURITY ────────────────────────────────────────────────────────────
  security.polkit.enable = true;
  security.rtkit.enable = true;
  security.sudo.wheelNeedsPassword = false;

  # ─── POWER SERVICES ──────────────────────────────────────────────────────
  services.power-profiles-daemon.enable = true; # Disable to prevent conflicts

  # ─── CORE SERVICES ───────────────────────────────────────────────────────
  services.fwupd.enable = true;
  services.flatpak.enable = true;
  services.openssh.enable = false;
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.login.enableGnomeKeyring = true;

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd sway";
        user = "greeter";
      };
    };
  };

  # ─── AUDIO (PipeWire) ─────────────────────────────────────────────────────
  services.pipewire.enable = true;
  services.pipewire.alsa.enable = true;
  services.pipewire.alsa.support32Bit = true;
  services.pipewire.pulse.enable = true;
  services.pipewire.wireplumber.enable = true;

  # ─── HARDWARE-SPECIFIC UDEV RULES ───────────────────────────────────────
  services.udev.extraRules = ''
    ACTION=="add", ENV{ID_INPUT_TOUCHSCREEN}=="1", ATTRS{name}=="ELAN901C:00 04F3:2CBF", ENV{LIBINPUT_IGNORE_DEVICE}="1"
  '';

  # ─── ENVIRONMENT ────────────────────────────────────────────────────────
  environment.systemPackages = corePackages;
  nixpkgs.config.allowUnfree = true;

  # ─── NIX SETTINGS ────────────────────────────────────────────────────────
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.settings.auto-optimise-store = true;
  nix.gc.automatic = true; # Automatic garbage collection
  nix.gc.dates = "weekly";
  nix.gc.options = "--delete-older-than 5d"; # Keep 3 days of generations

  # ---------- SYSTEM ----------
  fonts.packages = systemFonts; # Install system fonts
  system.stateVersion = "26.05"; # NixOS version (don't change lightly)

}
