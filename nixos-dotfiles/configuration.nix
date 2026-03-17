{
  config,
  pkgs,
  ...
}:

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
    nerd-fonts.jetbrains-mono
  ];

in

{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
  };

  networking.firewall.enable = true;
  networking.firewall.trustedInterfaces = [ "virbr0" ];
  networking.firewall.allowedTCPPorts = [ 24800 ];

  users.users.${userName} = {
    isNormalUser = true;
    description = userDescription;
    extraGroups = userGroups;
  };

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

  hardware.bluetooth.enable = false;
  hardware.bluetooth.powerOnBoot = true;
  hardware.graphics.enable = true;

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

  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.onBoot = "ignore";
  virtualisation.libvirtd.onShutdown = "suspend";

  security.polkit.enable = true;
  security.sudo.wheelNeedsPassword = false;

  services.power-profiles-daemon.enable = true;
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  services.gnome.core-apps.enable = false;
  services.gnome.core-developer-tools.enable = false;
  services.gnome.games.enable = false;

  services.pipewire.enable = true;
  services.pipewire.alsa.enable = true;
  services.pipewire.alsa.support32Bit = true;
  services.pipewire.pulse.enable = true;
  services.pipewire.wireplumber.enable = true;

  services.flatpak.enable = true;
  services.openssh.enable = true;

  services.kanata = {
    enable = true;
    keyboards = {
      default = {
        config = ''
          (defsrc
            caps
          )
          (defalias
            capsec (tap-hold 100 100 esc lctl)
          )
          (deflayer base
            @capsec
          )
        '';
      };
    };
  };

  services.udev.extraRules = ''
    ACTION=="add", ENV{ID_INPUT_TOUCHSCREEN}=="1", ATTRS{name}=="ELAN901C:00 04F3:2CBF", ENV{LIBINPUT_IGNORE_DEVICE}="1"
  '';

  environment.systemPackages = corePackages ++ gnomeExtensions;
  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome-user-docs
  ];

  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.settings.auto-optimise-store = true;
  nix.gc.automatic = true;
  nix.gc.dates = "weekly";
  nix.gc.options = "--delete-older-than 3d";

  systemd.services.virt-secret-init-encryption.enable = false;

  fonts.packages = systemFonts;

  system.stateVersion = "25.11";
}
