{ nixos-hardware }:
{
  desktop = {
    flakeTarget = "desktop";
    hostname = "desktop";
    hardwareConfig = ./hardware-configuration.desktop.nix;
    hardwareModules = [];
  };

  thinkpad = {
    flakeTarget = "thinkpad";
    hostname = "thinkpad-x13";
    hardwareConfig = ./hardware-configuration.thinkpad.nix;
    hardwareModules = [ nixos-hardware.nixosModules.lenovo-thinkpad-x13-intel ];
  };

  "macbook-pro" = {
    flakeTarget = "macbook-pro";
    hostname = "macbook-pro";
    hardwareConfig = ./hardware-configuration.macbook-pro.nix;
    hardwareModules = [ nixos-hardware.nixosModules.apple-macbook-pro-14-1 ];
  };
}
