#config.nix
{
  pkgs,
  lib,
  self,
  ...
}:
{
  # Install PKGS With System Parameters.
  programs = {
    # Native NixOS Modules
    niri.enable = true;
    uwsm = {
      enable = true;
      waylandCompositors = {
        niri = {
          prettyName = "Niri";
          comment = "Niri Scrollable Tiling Compositor Managed by UWSM.";
          binPath = "${pkgs.niri}/bin/niri";
        };
      };
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    gamemode = {
      enable = true;
      enableRenice = true;
      settings = {
        general = {
          renice = 20;
        };
        # Warning: GPU optimisations have the potential to damage hardware
        gpu = {
          apply_gpu_optimisations = "accept-responsibility";
          gpu_device = "NVIDIA";
          nv_powermode = "prefer-maximum-performance";
        };
        custom = {
          start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
          end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
        };
      };
    };
    gamescope = {
      enable = true;
      enableWsi = true;
      capSysNice = false;
    };
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      gamescopeSession = {
        enable = true;
        args = [
          "-W 1920"
          "-H 1080"
          "-r 239"
        ];
      };
      extraCompatPackages = [
        pkgs.proton-ge-bin
      ];
    };
    obs-studio = {
      enable = true;
      #package = (
      #  pkgs.obs-studio.override {
      #    cudaSupport = true;
      #  }
      #);
      plugins = let
        obs = pkgs.obs-studio-plugins;
      in [
        obs.wlrobs                  # Wayland direct screen capture (fallback for wl roots)
        obs.obs-pipewire-audio-capture # Direct PipeWire application audio routing
        obs.obs-vkcapture           # Vulkan/OpenGL game capture hook
        obs.obs-gstreamer           # GStreamer pipeline support
        obs.obs-vaapi               # Hardware encoding support (AMD/Intel)
      ];
    };
    nix-index-database.comma.enable = true;
    gpu-screen-recorder.enable = true;
    fish.enable = true;
    virt-manager.enable = true;
    nano.enable = false;
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
  };

  powerManagement.cpuFreqGovernor = "performance";

  # Time zone.
  time.timeZone = "America/New_York";

  # Origin NixOS install version, NEVER CHANGE.
  system = {
    stateVersion = "26.05";
    configurationRevision = lib.mkIf (self ? rev) self.rev;
    systemBuilderCommands = ''
      ln -s ${self} $out/src
    '';
  };
  # Old Code
  ### OBS-Debugging
  #PIPEWIRE_NODE = "1";
  #OBS_USE_EGL = "1";
  # Commented Out For OBS
  #LIBVA_DRIVER_NAME = "nvidia";
  ###NVD_BACKEND = "direct";
  #__GLX_VENDOR_LIBRARY_NAME = "nvidia";
  #AQ_DRM_DEVICES = "/dev/dri/by-path/pci-0000:01:00.0-card";
}
