{
  description = "Java template: Spring services";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      jdk = pkgs.jdk21;
    in {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          jdk
          gradle
          maven
          curl
          jq
        ];

        shellHook = ''
          export JAVA_HOME="${jdk}"
        '';
      };
    };
}
