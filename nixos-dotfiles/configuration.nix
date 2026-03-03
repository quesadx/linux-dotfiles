{ config, pkgs, ... }:

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
    git
    curl
    qemu_full
    virtio-win
    virt-manager
    steam-run
  ];

  systemFonts = with pkgs; [
    nerd-fonts.jetbrains-mono
    noto-fonts
    noto-fonts-color-emoji
    jetbrains-mono
    font-awesome
  ];

in
{
  imports = [ ./hardware-configuration.nix ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    firewall = {
      enable = true;
      trustedInterfaces = [ "virbr0" ];
      allowedTCPPorts = [ 24800 ]; # 24800 -> input-leap
    };
  };

  users.users.${userName} = {
    isNormalUser = true; # (non-root)
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

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    graphics.enable = true;
  };

  virtualisation = {
    docker.enable = true;
    docker.daemon.settings = {
      bip = "172.16.0.1/24";
      "default-address-pool" = [
        {
          base = "172.16.1.0/24";
          size = 24;
        }
      ];
    };
    libvirtd.enable = true;
    spiceUSBRedirection.enable = true;
  };
  # Default network script stuff
  systemd.services.libvirt-default-network = {
    description = "Start libvirt default network";
    after = [ "libvirtd.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.libvirt}/bin/virsh net-start default";
      ExecStop = "${pkgs.libvirt}/bin/virsh net-destroy default";
      User = "root";
    };
  };

  security = {
    polkit.enable = true;
    sudo.wheelNeedsPassword = false;
  };

  services = {
    power-profiles-daemon.enable = true;
    services.gnome.gnome-keyring.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };

    udev.extraRules = ''
      ACTION=="add", ENV{ID_INPUT_TOUCHSCREEN}=="1", ATTRS{name}=="ELAN901C:00 04F3:2CBF", ENV{LIBINPUT_IGNORE_DEVICE}="1"
    '';

    flatpak.enable = true;
    openssh.enable = true;
  };

  environment.systemPackages = corePackages;

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
      options = "--delete-older-than 5d";
    };
  };

  fonts.packages = systemFonts;

  system.stateVersion = "25.11";

}
