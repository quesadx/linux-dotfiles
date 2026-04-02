{
  description = "GNOME on NixOS";

  # ─── INPUTS ───────────────────────────────────────────────────────────────
  # External dependencies and package sources
  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";  # Use same nixpkgs as system
    };
  };

  # ─── OUTPUTS ──────────────────────────────────────────────────────────────
  # System configuration using flake inputs
  outputs = { self, nixpkgs, home-manager, ... }:
    let
      shared = import ./lib/shared.nix;
    in
    {
      nixosConfigurations.${shared.hostname} = nixpkgs.lib.nixosSystem {
        inherit (shared) system;
        specialArgs = { inherit shared; };

        modules = [
          ./configuration.nix  # System-level configuration

          home-manager.nixosModules.home-manager {  # User environment
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit shared; };
            home-manager.users.${shared.username} = import ./home/${shared.username}.nix;
          }
        ];
      };
    };
}
