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
  inherit (shared) username userDescription hostname timeZone locale regionalLocale;

  userGroups = [
    "networkmanager"
    "wheel"
    "video"
    "render"
    "audio"
    "docker"
    "kvm"
  ];

  corePackages = with pkgs; [
    # System utilities and virtualization
    vim wget curl                                                       # CLI tools
    steam-run                                                           # VM management and Steam runtime
  ];

  systemFonts = with pkgs; [
    ibm-plex                                                            # Professional sans-serif
    noto-fonts noto-fonts-color-emoji                                   # Unicode coverage
    font-awesome                                                        # Icon font
    nerd-fonts.jetbrains-mono                                           # Monospace with ligatures
  ];

in

# ============================================================================
# CONFIGURATION
# ============================================================================

{
  imports = [
    ./hardware-configuration.nix
    ./modules/desktop-gnome.nix
  ];

  # ---------------- KERNEL ----------------
  boot.kernelPackages = pkgs.linuxPackages_zen;

  # ---------- SWAP CONFIGURATION ----------
  zramSwap.enable = true;                                               # Creates a zram block device and uses it as a swap device
  zramSwap.memoryPercent = 75;                                          # Use 75% of available RAM for zram swap (adjust as needed)
  zramSwap.algorithm = "lz4";                                           # Fast compression algorithm
  systemd.oomd.enable = true;                                           # Enable OOMD to manage out-of-memory situations effectively

  # ---------- BOOT CONFIGURATION ----------
  boot.loader.systemd-boot.enable = true;                               # Use systemd-boot instead of GRUB
  boot.loader.efi.canTouchEfiVariables = true;

  # ---------- NETWORKING ----------
  networking = {
    hostName = hostname;
    networkmanager.enable = true;                                       # Use NetworkManager for system networking
  };

  # Firewall: Allow virbr0 (KVM bridge) and Synergy
  networking.firewall.enable = true;
  networking.firewall.trustedInterfaces = [ "virbr0" ];                 # KVM virtual bridge
  networking.firewall.allowedTCPPorts = [ 24800 ];                      # Synergy port

  # ---------- USERS ----------
  users.users.${username} = {
    isNormalUser = true;
    description = userDescription;
    extraGroups = userGroups;                                           # Add user to specified groups
  };

  # ---------- LOCALIZATION ----------
  time.timeZone = timeZone;

  i18n = {
    defaultLocale = locale;                                             # Default language
    extraLocaleSettings = {                                             # Regional settings for dates, numbers, money, etc.
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

  # ---------- HARDWARE ----------
  hardware.bluetooth.enable = true;                                     # Disabled
  hardware.bluetooth.powerOnBoot = true;                                # (kept in case needed)
  hardware.graphics.enable = true;                                      # GPU support

  # ---------- VIRTUALIZATION ----------
  virtualisation.docker.enable = true;
  virtualisation.docker.daemon.settings = {
    bip = "192.168.30.1/24";                                            # Bridge IP
    "default-address-pools" = [
      {
        base = "10.10.0.0/16";                                          # Container network range
        size = 24;
      }
    ];
  };

  # ---------- SECURITY ----------
  security.polkit.enable = true;                                        # PolicyKit for privilege escalation
  security.sudo.wheelNeedsPassword = false;                             # Wheel group members don't need password

  # ---------- SERVICES ----------
  services.power-profiles-daemon.enable = true;                         # Power management
  services.fwupd.enable = true;

  # Audio (PipeWire - modern audio server replacing PulseAudio)
  services.pipewire.enable = true;
  services.pipewire.alsa.enable = true;                                 # ALSA compatibility
  services.pipewire.alsa.support32Bit = true;                           # 32-bit app support
  services.pipewire.pulse.enable = true;                                # PulseAudio compatibility
  services.pipewire.wireplumber.enable = true;                          # Session/device management

  # Other services
  services.flatpak.enable = true;                                       # Sandboxed application support
  services.openssh.enable = true;                                       # SSH server

  # Disable touchscreen (ELAN901C:00) - specific to hardware
  services.udev.extraRules = ''
    ACTION=="add", ENV{ID_INPUT_TOUCHSCREEN}=="1", ATTRS{name}=="ELAN901C:00 04F3:2CBF", ENV{LIBINPUT_IGNORE_DEVICE}="1"
  '';

  # ---------- ENVIRONMENT ----------
  environment.systemPackages = corePackages;
  nixpkgs.config.allowUnfree = true;                                    # Allow proprietary software

  # ---------- NIX SETTINGS ----------
  nix.settings.experimental-features = [
    "nix-command"                                                       # New nix CLI
    "flakes"                                                            # Flakes support
  ];
  nix.settings.auto-optimise-store = true;                              # Deduplicate store files
  nix.gc.automatic = true;                                              # Automatic garbage collection
  nix.gc.dates = "weekly";
  nix.gc.options = "--delete-older-than 5d";                            # Keep 3 days of generations

  # ---------- SYSTEM ----------
  fonts.packages = systemFonts;                                         # Install system fonts
  system.stateVersion = "26.05";                                        # NixOS version (don't change lightly)

}
