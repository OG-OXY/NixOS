{
  config,
  lib,
  ...
}: {
  services.xserver.videoDrivers = [
    "nvidia"
  ];
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
      open = false;
      nvidiaSettings = true;
      package = lib.mkDefault config.boot.kernelPackages.nvidiaPackages.legacy_580;
    };
  };
}
