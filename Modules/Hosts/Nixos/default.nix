{
  inputs,
  self,
  ...
}:
{
  flake.nixosConfigurations."nixos" = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = { inherit inputs self; };
    modules = [
      {
        nixpkgs = {
          hostPlatform = "x86_64-linux";
          config = {
            allowUnfree = true;
            cudaSupport = true;
            cudaCapabilities = ["6.1"];
            permittedInsecurePackages = [
              "electron-39.8.10"
              "ventoy-1.1.17"
            ];
          };
          overlays = [
            (_final: prev: 
            let
                stable = import inputs.nixpkgs-stable {
                inherit (prev) system;
                config = prev.config;
              };
            in {
                hello = stable.hello;
                cudaPackages = prev.cudaPackages_12_9;
                # ffmpeg = prev.ffmpeg_6;
                # ffmpeg-full = prev.ffmpeg_6-full;
            })
          ];
        };
        hardware.enableRedistributableFirmware = true;
      }
      ../../../config.nix
      inputs.chaotic.nixosModules.default
      inputs.home-manager.nixosModules.home-manager
      inputs.sops.nixosModules.sops
      inputs.nirinit.nixosModules.nirinit
      inputs.rusty-clip.nixosModules.default
      inputs.nix-index-database.nixosModules.default
      #inputs.stylix.nixosModules.stylix
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          backupFileExtension = ".bak";
          sharedModules = builtins.attrValues self.homeModules;
          users = {
            root = import ../../../Homes/root.nix;
            ty = import ../../../Homes/ty.nix;
          };
          extraSpecialArgs = {inherit inputs self;};
        };
      }
    ] ++ (builtins.attrValues self.nixosModules);
  };
}
