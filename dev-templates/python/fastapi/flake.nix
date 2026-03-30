{
  description = "Python template: FastAPI";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          python3
          uv
          python3Packages.fastapi
          python3Packages.uvicorn
          python3Packages.pytest
          python3Packages.httpx
          python3Packages.ruff
        ];
      };
    };
}
