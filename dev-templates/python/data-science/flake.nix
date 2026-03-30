{
  description = "Python template: Data science";

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
          python3Packages.jupyterlab
          python3Packages.numpy
          python3Packages.pandas
          python3Packages.matplotlib
          python3Packages.seaborn
          python3Packages.scikit-learn
        ];
      };
    };
}
