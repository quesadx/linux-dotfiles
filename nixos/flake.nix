{
  description = "GNOME on NixOS";

  # ─── INPUTS ───────────────────────────────────────────────────────────────
  # External dependencies and package sources
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

  };

  # ─── OUTPUTS ──────────────────────────────────────────────────────────────
  # System configuration using flake inputs
  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nixos-hardware,
      ...
    }:
    let
      shared = import ./lib/shared.nix;
      hosts = import ./hosts.nix { inherit nixos-hardware; };
      hostNames = builtins.attrNames hosts;
    in
    {
      nixosConfigurations = builtins.listToAttrs (map (name: {
          name = name;
          value = nixpkgs.lib.nixosSystem {
            inherit (shared) system;
            specialArgs = {
              inherit shared hosts;
              host = hosts.${name};
            };
            modules = [
              ./configuration.nix
              hosts.${name}.hardwareConfig
            ] ++ hosts.${name}.hardwareModules ++ [
              home-manager.nixosModules.home-manager
              {
                # User environment
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.extraSpecialArgs = {
                  inherit shared;
                  host = hosts.${name};
                };
                home-manager.users.${shared.username} = import ./home/${shared.username}.nix;
              }
            ];
          };
        }
      ) hostNames);
    };
}
