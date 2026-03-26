{
  config,
  pkgs,
  ...
}:

# ============================================================================
# VARIABLES - Centralized configuration values for easy maintenance
# ============================================================================

let
  userName = "quesadx";
  userDescription = "Matteo Quesada";
  timeZone = "America/Costa_Rica";
  locale = "en_US.UTF-8";             # Display language
  regionalLocale = "es_CR.UTF-8";     # Regional format (numbers, dates, etc.)

  userGroups = [
    "networkmanager"
    "wheel"
    "video"
    "render"
    "audio"
    "scanner"
    "docker"
    "kvm"
    "libvirtd"
  ];

  corePackages = with pkgs; [
    # System utilities and virtualization
    vim wget curl             # CLI tools
    qemu virtio-win          # QEMU/KVM virtualization
    virt-manager steam-run   # VM management and Steam runtime
    dnsmasq                  # DNS/DHCP server
  ];

  systemFonts = with pkgs; [
    ibm-plex                    # Professional sans-serif
    noto-fonts noto-fonts-color-emoji  # Unicode coverage
    font-awesome                # Icon font
    nerd-fonts.jetbrains-mono   # Monospace with ligatures
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

  # ---------- BOOT CONFIGURATION ----------
  boot.loader.systemd-boot.enable = true;  # Use systemd-boot instead of GRUB
  boot.loader.efi.canTouchEfiVariables = true;

  # ---------- NETWORKING ----------
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;  # Use NetworkManager for system networking
  };

  # Firewall: Allow virbr0 (KVM bridge) and Synergy
  networking.firewall.enable = true;
  networking.firewall.trustedInterfaces = [ "virbr0" ];  # KVM virtual bridge
  networking.firewall.allowedTCPPorts = [ 24800 ];       # Synergy port

  # ---------- USERS ----------
  users.users.${userName} = {
    isNormalUser = true;
    description = userDescription;
    extraGroups = userGroups;  # Add user to specified groups
  };

  # ---------- LOCALIZATION ----------
  time.timeZone = timeZone;

  i18n = {
    defaultLocale = locale;  # Default language
    extraLocaleSettings = {  # Regional settings for dates, numbers, money, etc.
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
  hardware.bluetooth.enable = true;        # Disabled
  hardware.bluetooth.powerOnBoot = true;    # (kept in case needed)
  hardware.graphics.enable = true;          # GPU support

  # ---------- VIRTUALIZATION ----------
  virtualisation.docker.enable = true;
  virtualisation.docker.daemon.settings = {
    bip = "192.168.30.1/24";            # Bridge IP
    "default-address-pools" = [
      {
        base = "10.10.0.0/16";           # Container network range
        size = 24;
      }
    ];
  };

  virtualisation.libvirtd.enable = true;     # Enable KVM/QEMU
  virtualisation.libvirtd.onBoot = "ignore";  # Don't auto-start VMs
  virtualisation.libvirtd.onShutdown = "suspend"; # Suspend VMs on shutdown

  # ---------- SECURITY ----------
  security.polkit.enable = true;               # PolicyKit for privilege escalation
  security.sudo.wheelNeedsPassword = false;    # Wheel group members don't need password

  # ---------- SERVICES ----------
  services.power-profiles-daemon.enable = true;  # Power management

  # Audio (PipeWire - modern audio server replacing PulseAudio)
  services.pipewire.enable = true;
  services.pipewire.alsa.enable = true;       # ALSA compatibility
  services.pipewire.alsa.support32Bit = true; # 32-bit app support
  services.pipewire.pulse.enable = true;      # PulseAudio compatibility
  services.pipewire.wireplumber.enable = true; # Session/device management

  # Other services
  services.flatpak.enable = true;        # Sandboxed application support
  services.openssh.enable = true;        # SSH server

  # Disable touchscreen (ELAN901C:00) - specific to hardware
  services.udev.extraRules = ''
    ACTION=="add", ENV{ID_INPUT_TOUCHSCREEN}=="1", ATTRS{name}=="ELAN901C:00 04F3:2CBF", ENV{LIBINPUT_IGNORE_DEVICE}="1"
  '';

  # ---------- ENVIRONMENT ----------
  environment.systemPackages = corePackages;
  nixpkgs.config.allowUnfree = true;  # Allow proprietary software

  # ---------- NIX SETTINGS ----------
  nix.settings.experimental-features = [
    "nix-command"  # New nix CLI
    "flakes"       # Flakes support
  ];
  nix.settings.auto-optimise-store = true;  # Deduplicate store files
  nix.gc.automatic = true;                  # Automatic garbage collection
  nix.gc.dates = "weekly";
  nix.gc.options = "--delete-older-than 3d"; # Keep 3 days of generations

  # ---------- SYSTEM ----------
  systemd.services.virt-secret-init-encryption.enable = false;  # Disable encryption init

  fonts.packages = systemFonts;                   # Install system fonts

  system.stateVersion = "25.11";                 # NixOS version (don't change lightly)

}
