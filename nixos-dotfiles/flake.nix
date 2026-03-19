{
  description = "GNOME on NixOS";

  # ============================================================================
  # INPUTS - External dependencies and package sources
  # ============================================================================

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs"; # Use same nixpkgs as system
    };
  };

  # ============================================================================
  # OUTPUTS - System configuration using flake inputs
  # ============================================================================

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux"; # Architecture
      hostname = "nixos";       # Machine name
      username = "quesadx";     # Primary user
    in

    {
      nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem {
        inherit system;

        modules = [
          ./configuration.nix  # System-level configuration

          home-manager.nixosModules.home-manager {  # User environment
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${username} = import ./home.nix;
          }
        ];
      };
    };
}