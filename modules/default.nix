{ self, inputs, ... }: {
  flake.nixosConfigurations."nixos" = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = { inherit inputs self; };
    modules = [
      {
        nixpkgs = {
          hostPlatform = "x86_64-linux";
          config = {
            allowUnfree = true;
            cudaSupport = true;
            cudaCapabilities = [ "6.1" ];
            permittedInsecurePackages = [
              "electron-39.8.10"
            ];
          };
        };
        hardware.enableRedistributableFirmware = true;
      }
      (map inputs.import-tree [
        ./system
        ./hosts
      ])     
      ./nixos/default.nix
      ./nixos/hardware.nix
      ./nixos/hacker.nix
      inputs.chaotic.nixosModules.default
      inputs.sops.nixosModules.sops
      inputs.stylix.nixosModules.stylix
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          backupFileExtension = ".bak";
          users = {
            root = import ./home/modules/root-home.nix; # Adjust path if needed
            ty = import ./home/modules/ty-home.nix;     # Adjust path if needed
          };
          extraSpecialArgs = { inherit inputs self; };
        };
      }
    ];
  };
}
