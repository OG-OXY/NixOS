{
  ...
}:
{
  flake.nixosModules.nvidia = { pkgs, config, ... }:
    {
      services = {
        xserver = {
          videoDrivers = [
            "nvidia"
          ];
          screenSection = ''
            Option "Coolbits" "4"
            Option "RandRRotation" "on"
          '';
        };
        lact.enable = true;
      };
      hardware = {
        uinput.enable = true;
        i2c.enable = true;
        keyboard.qmk.enable = true;
        bluetooth = {
          enable = true;
          powerOnBoot = true;
          settings.General.Experimental = true;
        };
        graphics = {
          enable = true;
          enable32Bit = true;
          extraPackages32 = [
            pkgs.pkgsi686Linux.nvidia-vaapi-driver
          ];
        };
        nvidia = {
          modesetting.enable = true;
          powerManagement.enable = false;
          powerManagement.finegrained = false;
          open = false;
          nvidiaSettings = true;
          branch = "legacy_580";
          package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
        };
      };
    };
}
