{config, ...}: {
  services.xserver.videoDrivers = [
    "nvidia"
    "amdgpu"
  ];
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    nvidia = {
      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
        amdgpuBusId = "PCI:14:0:0"; #Internal
        nvidiaBusId = "PCI:1:0:0"; #External
      };
      modesetting.enable = true;
      powerManagement.enable = true;
      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
    };
  };
}
