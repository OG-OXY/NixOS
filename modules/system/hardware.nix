{
  pkgs,
  lib,
  modulesPath,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  specialisation = {
    NYXOS.configuration = {
      system.nixos.label = "NYXOS";
      boot = {
        loader.grub.configurationName = "NYXOS";
        kernelPackages = pkgs.linuxPackages_cachyos-lto-znver4;
      };
    };
    NIXOS.configuration = {
      system.nixos.label = "NIXOS";
      boot = {
        loader.grub.configurationName = "NIXOS";
        kernelPackages = pkgs.linuxPackages_cachyos-lts;
      };
    };
    NIXOS-HACKER.configuration = {
      system.nixos.label = "NIXOS-HACKER";
      boot = {
        loader.grub.configurationName = "NIXOS-HACKER";
        kernelPackages = pkgs.linuxPackages_cachyos-hardened;
      };
    };
  };

  boot = {
    loader = {
      grub = {
        enable = true;
        efiSupport = true;
        useOSProber = true;
        device = "nodev";
        configurationLimit = 30;
        default = "saved";
      };
      efi = {
        canTouchEfiVariables = true;
      };
    };
    plymouth = {
      enable = true;
      theme = "breeze";
    };
    initrd = {
      kernelModules = [
        "amdgpu"
        "nvidia"
        "nvidia_modeset"
        "nvidia_uvm"
        "nvidia_drm"
      ];
      availableKernelModules = [
        "xhci_pci"
        "ahci"
        "nvme"
        "usbhid"
        "sd_mod"
      ];
    };
    kernelModules = [
      "kvm-amd"
      "vfio"
      "vfio_iommu_type1"
      "vfio_pci"
      "i2c-dev"
      "i2c-piix4"
    ];
    extraModulePackages = [ ];
    kernelParams = [
      "quiet"
      "splash"
      "processor.max_cstate=0"
      "amd_idle.max_cstate=0"
      "amd_iommu=on"
      "iommu=pt"
      "nvidia-drm.modeset=1"
    ];
    kernel.sysctl = {
      "kernel.sysrq" = true;
      "kernel.unprivileged_userns_clone" = 1;
      "vm.max_map_count" = 2147483642;
      "vm.swappiness" = 100;
      "vm.dirty_background_ratio" = 5;
      "vm.dirty_ratio" = 10;
      "fs.inotify.max_user_watches" = 524288;
    };
    binfmt.emulatedSystems = [ "aarch64-linux" ];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-partlabel/NixOS";
      fsType = "ext4";
      options = [
        "nofail"
        "noatime"
        "nodiratime"
      ];
    };
    "/boot" = {
      device = "/dev/disk/by-partlabel/NixOS-BOOT";
      fsType = "vfat";
      options = [
        "fmask=0022"
        "dmask=0022"
      ];
    };
    "/home/ty/2TB-HDD" = {
      device = "/dev/disk/by-partlabel/2TB-HDD";
      fsType = "ext4";
      options = [
        "defaults"
        "nofail"
        "exec"
        "noatime"
        "x-systemd.automount"
        "x-systemd.device-timeout=5s"
        "x-systemd.idle-timeout=10m"
      ];
    };
    "/home/ty/400GB-HDD" = {
      device = "/dev/disk/by-partlabel/400GB-HDD";
      fsType = "ext4";
      options = [
        "defaults"
        "nofail"
        "exec"
        "x-systemd.automount"
        "x-systemd.device-timeout=5s"
      ];
    };
    "/home/ty/Ventoy" = {
      device = "/dev/disk/by-label/Ventoy";
      fsType = "exfat";
      options = [
        "defaults"
        "nofail"
        "x-systemd.automount"
        "x-systemd.device-timeout=5s"
      ];
    };
  };
}
