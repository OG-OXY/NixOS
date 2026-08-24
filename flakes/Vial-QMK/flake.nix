{
  description = "QMK development environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs =
    { nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        name = "QMK-ENV";
        nativeBuildInputs = [
          pkgs.git
          pkgs.gnumake
          pkgs.qmk
          pkgs.dfu-programmer
          pkgs.dfu-util
          pkgs.avrdude
          pkgs.gcc-arm-embedded
        ];

        shellHook = ''
          echo "⚡ QMK Development Environment Loaded ⚡"
          export QMK_HOME="$PWD/vial-qmk" 
        '';
      };
    };
}
