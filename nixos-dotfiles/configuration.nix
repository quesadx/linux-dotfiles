{
  config,
  pkgs,
  ...
}:

# ============================================================================
# VARIABLES
# ============================================================================

let
  userName = "quesadx";
  userDescription = "Matteo Quesada";
  timeZone = "America/Costa_Rica";
  locale = "en_US.UTF-8";
  regionalLocale = "es_CR.UTF-8";

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
    #"vboxusers"
  ];

  corePackages = with pkgs; [
    vim
    wget
    curl
    qemu
    virtio-win
    virt-manager
    steam-run
    dnsmasq
  ];

  gnomeExtensions = with pkgs.gnomeExtensions; [
    alphabetical-app-grid
    auto-accent-colour
    caffeine
    clipboard-history
    luminus-desktop
    top-bar-organizer
    appindicator
  ];

  systemFonts = with pkgs; [
    ibm-plex
    noto-fonts
    noto-fonts-color-emoji
    font-awesome
  ];

in

# ============================================================================
# CONFIGURATION
# ============================================================================

{
  imports = [ ./hardware-configuration.nix ];

  # ========================================================================
  # Boot
  # ========================================================================

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  # ========================================================================
  # Networking
  # ========================================================================

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    firewall = {
      enable = true;
      trustedInterfaces = [ "virbr0" ];
      allowedTCPPorts = [ 24800 ]; # 24800 -> input-leap
    };
  };

  # ========================================================================
  # Users
  # ========================================================================

  users.users.${userName} = {
    isNormalUser = true; # (non-root)
    description = userDescription;
    extraGroups = userGroups;
  };

  # ========================================================================
  # Time & Locale
  # ========================================================================

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

  # ========================================================================
  # Hardware
  # ========================================================================

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    graphics.enable = true;
  };

  # ========================================================================
  # Virtualization
  # ========================================================================

  virtualisation = {
    docker.enable = true;
    docker.daemon.settings = {
      bip = "192.168.30.1/24";
      "default-address-pools" = [
        {
          base = "192.168.31.0/24";
          size = 24;
        }
      ];
    };
    #virtualbox = {
    #host = {
    #enable = true;
    #enableExtensionPack = true;
    #};
    #};

    # sudo virsh net-start default
    # sudo virsh net-autostart default
    libvirtd = {
      enable = true;
      onBoot = "ignore";
      onShutdown = "suspend";
    };
    #spiceUSBRedirection.enable = true;
  };

  # ========================================================================
  # Security
  # ========================================================================

  security = {
    polkit.enable = true;
    sudo.wheelNeedsPassword = false;
  };

  # ========================================================================
  # Services
  # ========================================================================

  services = {
    power-profiles-daemon.enable = true;
    # GNOME stuff
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    gnome.core-apps.enable = false;
    gnome.core-developer-tools.enable = false;
    gnome.games.enable = false;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };
    # Disable touchscreen
    udev.extraRules = ''
      ACTION=="add", ENV{ID_INPUT_TOUCHSCREEN}=="1", ATTRS{name}=="ELAN901C:00 04F3:2CBF", ENV{LIBINPUT_IGNORE_DEVICE}="1"
    '';

    flatpak.enable = true;
    openssh.enable = true;
  };

  # ========================================================================
  # Environment & Packages
  # ========================================================================

  environment.systemPackages = corePackages ++ gnomeExtensions;
  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome-user-docs
  ];

  # ========================================================================
  # Nix Configuration
  # ========================================================================

  nixpkgs.config.allowUnfree = true;

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 3d";
    };
  };

  # ========================================================================
  # Systemd
  # ========================================================================

  # This is required to avoid the following error when using virt-manager:
  # virt-secret-init-encryption.service: Unable to locate executable '/usr/bin/sh': No such file or directory
  systemd.services.virt-secret-init-encryption.enable = false;

  # ========================================================================
  # Fonts
  # ========================================================================

  fonts.packages = systemFonts;

  system.stateVersion = "25.11";
}
