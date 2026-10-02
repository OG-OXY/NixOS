{
  ...
}:
{
  flake.nixosModules.nvidia =
    { config, ... }:
    {
      services.xserver.videoDrivers = [
        "nvidia"
      ];
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
        };
        nvidia = {
          #prime = {
          #  offload = {
          #    enable = false;
          #    enableOffloadCmd = false;
          #  };
          #amdgpuBusId = "PCI:14:0:0"; # Internal
          #nvidiaBusId = "PCI:1:0:0"; # External
          #};
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
