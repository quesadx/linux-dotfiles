{
  description = "Python Development Environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          python314
          python314Packages.pip
          python314Packages.virtualenv
          python314Packages.pytest
          python314Packages.black
          python314Packages.flake8
          # python312Packages.python-lsp-server
        ];
      };
    };
}

