{ nixos-hardware }:
{
  desktop = {
    hostname = "desktop";
    hardwareConfig = ./hardware-configuration.desktop.nix;
    hardwareModules = [];
  };

  thinkpad = {
    hostname = "thinkpad-x13";
    hardwareConfig = ./hardware-configuration.thinkpad.nix;
    hardwareModules = [ nixos-hardware.nixosModules.lenovo-thinkpad-x13-intel ];
  };

  macbook = {
    hostname = "macbook-pro";
    hardwareConfig = ./hardware-configuration.macbook.nix;
    hardwareModules = [ nixos-hardware.nixosModules.apple-macbook-pro-14-1 ];
  };
}
