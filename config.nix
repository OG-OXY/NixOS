#config.nix
{
  pkgs,
  lib,
  self,
  ...
}:
{
  programs = {
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
      ## Commenting out and setting to false removed VK swapchain error popup from steam desktop and allowed me to launch mordhau and everything else in steam-desktop, still dont know why gamescope isnt working.
      enableWsi = false;
      ##
      # Commented out after steam-desktop worked
      #capSysNice = false;
    };
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      gamescopeSession = {
        enable = true;
        args = [
          "-W" "1920"
          "-H" "1080"
          "-r" "239"
          "-w" "1280"
          "-h" "720"
          # Upscaler selection & sharpening
          "-F" "fsr"                  # Options: fsr, nis
          #"--fsr-sharpness 4"       # 0 = max sharp, 20 = minimum sharp
          # Display & session flags
          "-e"                      # Enable Steam Gamepad UI / Embedded mode
          "--fs"                    # Native fullscreen
          "--force-windows-fullscreen"
          "--rt"                    # Real-time process scheduling for lower latency
          "--expose-wayland"
          # CRITICAL FOR DUAL-GPU: PCI ID for GTX 1070 (10de = NVIDIA, 1b81 = GTX 1070)
          "--prefer-vk-device" "10de:1b81"
        ];
        env = {
          # Not sure if this works or is causing issues was in my sessionVars but is now commented out there
          GAMESCOPE_WSI_ENABLE = "0";
          DXVK_FILTER_DEVICE_NAME = "\"GeForce GTX 1070\"";
          GBM_BACKEND = "nvidia-drm";
          __GLX_VENDOR_LIBRARY_NAME = "nvidia";
          VK_DRIVER_FILES = "/run/opengl-driver/share/vulkan/implicit_layer.d/nvidia_icd.x86_64.json";
          GDK_BACKEND = "x11";
          QT_QPA_PLATFORM = "xcb";
          WLR_NO_HARDWARE_CURSORS = "0";
          PROTON_ENABLE_NVAPI = "1";
          STEAM_EXTRA_COMPAT_TOOLS_PATHS = "$HOME/.steam/root/compatibilitytools.d";
        };
        steamArgs = [
          # Redundant?
          #"-gamepadui"
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
      plugins =
        let
          obs = pkgs.obs-studio-plugins;
        in
        [
          obs.wlrobs # Wayland direct screen capture (fallback for wl roots)
          obs.obs-pipewire-audio-capture # Direct PipeWire application audio routing
          obs.obs-vkcapture # Vulkan/OpenGL game capture hook
          obs.obs-gstreamer # GStreamer pipeline support
          obs.obs-vaapi # Hardware encoding support (AMD/Intel)
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
