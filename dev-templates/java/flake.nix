{
  description = "Java Development Environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      jdk = pkgs.jdk21.override { enableJavaFX = true; };
    in {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          jdk
          maven
          javaPackages.openjfx21
        ];

        shellHook = ''
          export JAVA_HOME="${jdk}"
        '';
      };
    };
}
