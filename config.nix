#config.nix
{
  pkgs,
  lib,
  inputs,
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

  # Install system PKGS.
  environment = {
    shells = [ pkgs.fish ];
    variables = {
      CPATH = "/run/current-system/sw/include";
      LIBRARY_PATH = "/run/current-system/sw/lib";
    };
    sessionVariables = {
      XDG_CURRENT_DESKTOP = "niri:GNOME";
      NIXOS_OZONE_WL = "1";
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
      XDG_SESSION_TYPE = "wayland";
      GDK_BACKEND = "wayland,x11";
      GBM_BACKEND = "nvidia-drm";
      QT_QPA_PLATFORM = "wayland;xcb";
      SDL_VIDEO_DRIVER = "wayland,x11";
      #PIPEWIRE_NODE = "2";
      #OBS_USE_EGL = "0";
      #WLR_RENDERER = "vulkan"; 
      PROTON_ENABLE_WAYLAND = "1";
      PROTON_ENABLE_NVAPI = "1";
      ENABLE_GAMESCOPE_WSI = "1";
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "$HOME/.steam/root/compatibilitytools.d";
      WLR_NO_HARDWARE_CURSORS = "0";
      EDITOR = "nvf";
      VISUAL = "nvf";
      SSH_AUTH_SOCK = "/home/ty/.bitwarden-ssh-agent.sock";
      SECRETSPEC_PROVIDER = "keyring";
      ANTHROPIC_API_KEY = "local";
      ANTHROPIC_AUTH_TOKEN = "ollama";
      ANTHROPIC_BASE_URL = "http://127.0.0.1:11434";
      ANTHROPIC_DEFAULT_SONNET_MODEL = "qwen-32b";
      ANTHROPIC_DEFAULT_OPUS_MODEL = "qwen2.5-coder";
      ANTHROPIC_DEFAULT_HAIKU_MODEL = "qwen2.5-coder";
      OLLAMA_CONTEXT_LENGTH = "32768";
      CLAUDE_CODE_ATTRIBUTION_HEADER = "0";
      CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC = "1";
      NODE_OPTIONS = "--dns-result-order=ipv4first";
    };
    systemPackages = let
      Cuda = pkgs.cudaPackages;
      Kde = pkgs.kdePackages;
      Gst = pkgs.gst_all_1;
      Gsr = pkgs.gpu-screen-recorder.override {
        ffmpeg = pkgs.ffmpeg_6; # Uses NVENC API 13.0 compatible headers
      };
    in
    [
      pkgs.stdenv.cc
      pkgs.binutils
      pkgs.gnumake
      pkgs.cmake
      pkgs.pkg-config
      pkgs.gdb
      pkgs.valgrind
      pkgs.polkit_gnome
      pkgs.watchman
      pkgs.pinentry-qt
      pkgs.xwayland-satellite
      pkgs.noctalia-shell
      pkgs.ghostty
      pkgs.yazi
      pkgs.bitwarden-desktop
      pkgs.vesktop
      pkgs.pavucontrol
      pkgs.pipewire
      pkgs.slurp
      pkgs.grim
      pkgs.pulseaudio
      pkgs.pulseaudio-ctl
      pkgs.qalculate-gtk
      pkgs.lutris
      pkgs.steam-run
      pkgs.protonup-ng
      pkgs.winetricks
      pkgs.wine
      pkgs.wine-staging
      pkgs.wineWow64Packages.staging
      pkgs.gnutls
      pkgs.xinit
      pkgs.ttyd
      pkgs.git
      pkgs.gh
      pkgs.nix-output-monitor
      pkgs.nvd
      pkgs.nh
      pkgs.just
      pkgs.fh
      pkgs.rbw
      pkgs.secretspec
      pkgs.sops
      pkgs.age
      pkgs.rofi-rbw-wayland
      pkgs.ffmpeg_6-full
      pkgs.mpv
      pkgs.mpd
      pkgs.imv
      pkgs.btop
      pkgs.tree
      pkgs.dysk
      pkgs.tealdeer
      pkgs.wl-clipboard
      pkgs.cliphist
      pkgs.wtype
      pkgs.curl
      pkgs.w3m
      pkgs.wget
      pkgs.wget2
      pkgs.fzf
      pkgs.ripgrep
      pkgs._7zz
      pkgs.poppler-utils
      pkgs.imagemagick
      pkgs.resvg
      pkgs.aider-chat
      pkgs.fd
      pkgs.bun
      pkgs.devenv
      pkgs.starship
      pkgs.fastfetch
      pkgs.atuin
      pkgs.libnotify
      pkgs.aria2
      pkgs.monero-cli
      pkgs.easyeffects
      pkgs.quickshell
      Kde.qtdeclarative
      Kde.qtsvg
      Kde.qt5compat
      Kde.kwin
      pkgs.devenv
      pkgs.nixfmt
      pkgs.jq
      pkgs.bat
      pkgs.ventoy
      pkgs.wl-screenrec
      pkgs.lolcat
      Gst.gstreamer
      Gst.gst-plugins-base
      Gst.gst-plugins-good
      Gst.gst-plugins-bad
      Gst.gst-plugins-ugly
      Gsr
      # For Dendritic Test-VM
      pkgs.xhost
      # Audio Wiring
      #pkgs.qpwgraph
      pkgs.helvum
      # Wifi Monitor Tools
      pkgs.iw
      pkgs.wavemon
      # Nix Config to XML
      pkgs.repomix
      # Disabled PKGS
      #pkgs.sway
      #pkgs.delicious-sddm-theme
      # Hyprland Ecosystem
      #pkgs.hyprpolkitagent
      #pkgs.waybar
      #pkgs.mako
      #pkgs.wofi
      #pkgs.hyprshot
      #pkgs.hyprpicker
      #pkgs.hyprpaper
    ]
    ++ [
      inputs.zen-browser.packages.${pkgs.system}.default
      inputs.nvf.packages.${pkgs.system}.default
      #inputs.llm-agents.packages.${pkgs.system}.default
      Cuda.cuda_nvcc
      Cuda.cudatoolkit
    ];
    etc = {
      "NetworkManager/dnsmasq.d/fallback-dns.conf".text = ''
        no-resolv
        server=1.1.1.1
        server=1.0.0.1
        server=9.9.9.9
        all-servers
      '';
      "greetd/sway-config".text = lib.mkForce ''
        exec regreet
        output "ASUSTek COMPUTER INC ROG PG258Q ASP9OUVfHcfd" mode 1920x1080@240 pos 0 0
        output "Dell Inc. DELL P2720D K6RX299P10LS" mode 2560x1440@59 pos 1920 -180
        seat * hide_cursor 3000
      '';
      #OBS DEBUGGING
      "xdg/xdg-desktop-portal-wlr/config".text = ''
        [screencast]
        force_linear = true
      '';
    };
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

  # Display Manager.
  services = {
    xserver = {
      enable = true;
      extraConfig = ''
        Section "ServerFlags"
          Option "AutoAddGPU" "true"
        EndSection
      
        Section "Device"
          Identifier "GTX1070"
          Driver "nvidia"
          BusID "PCI:1:0:0"
        EndSection
      '';
    };
    displayManager = {
      noctalia-greeter = {
        enable = true;
        settings = {
          # Force specific primary monitor if auto-detection picks the wrong one
          monitor = "ASUSTek COMPUTER INC ROG PG258Q #ASP9OUVfHcfd"; 
          #cursor = {
          #  theme = "Saturn";
          #  size = 32;
          #};
          appearance = {
            wallpaper = "/home/ty/NixOS/Master/Config/Theme/Wpapers/gruvbox-rainbow-nix.png";
            blur = true;
          };
        };
      };
    };
    #desktopManager.xterm.enable = false;
    greetd = {
      enable = true;
      settings = {
        # lib.mkForce's Are Because Broken ASS Regreet Module Default Setting Weights.
        default-session = {
          command = "${pkgs.noctalia-greeter}/bin/noctalia-greeter";
          user = "greetd";
        };
      };
    }; 
    #hardware.openrgb = {
    #  enable = true;
    #  package = pkgs.openrgb-with-all-plugins;
    #  motherboard = "amd";
    #};
    logind.settings = {
      Login = {
        IdleAction = "ignore";
        HandlePowerKey = "ignore";
        HandleLidSwitch = "ignore";
        HandleLidSwitchExternalPower = "ignore";
      };
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      extraConfig.pipewire = {
        "99-client-quality" = {
          "context.properties" = {
            "default.clock.rate" = 48000;
            "default.clock.allowed-rates" = [ 44100 48000 96000 ];
            "default.clock.quantum" = 512;
            "default.clock.min-quantum" = 32;
            "default.clock.max-quantum" = 2048;
          };
        };
      };
    };
    zram-generator = {
      enable = true;
      settings = {
        zram0 = {
          compression-algorithm = "lz4";
          zram-size = 16384;
        };
      };
    };
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
    };
    #ollama = {
    #  enable = true;
    #  package = (pkgs.ollama-cuda.override { }).overrideAttrs (oldAttrs: {
    #    cmakeFlags = (oldAttrs.cmakeFlags or [ ]) ++ [
    #      "-DCMAKE_CUDA_ARCHITECTURES=61"
    #    ];
    #  });
    #  environmentVariables = {
    #    CUDA_VISIBLE_DEVICES = "0";
    #    OLLAMA_GPU_OVERHEAD = "512";
    #  };
    #};
    #llama-cpp = {
    #  enable = true;
    #  settings = {
    #    hf-repo = "Qwen/Qwen2.5-Coder-32B-Instruct-GGUF";
    #    hf-file = "qwen2.5-coder-32b-instruct-q4_k_m.gguf";
    #    host = "0.0.0.0";
    #    port = 8012;
    #    jinja = true;
    #    flash-attn = "on";
    #    ctx-size = 32768;
    #    cache-type-k = "q8_0";
    #    cache-type-v = "q8_0";
    #    n-gpu-layers = 40;
    #  };
    #  package =
    #    (pkgs.llama-cpp.override {
    #      cudaSupport = true;
    #    }).overrideAttrs
    #      (oldAttrs: {
    #        cmakeFlags = (oldAttrs.cmakeFlags or [ ]) ++ [
    #          "-DCMAKE_CUDA_ARCHITECTURES=61"
    #        ];
    #      });
    #};
    kmscon = {
      enable = true;
      config = {
        hwaccel = true;
        colors = "#121212,#ff4433,#33cc55,#ffaa22,#2255ff,#cc33ff,#00e5ff,#e0e0e0,#555555,#ff6655,#55ff77,#ffcc44,#4477ff,#ff55ff,#55ffff,#ffffff";
      };
    };
    dbus.enable = true;
    tailscale.enable = true;
    power-profiles-daemon.enable = true;
    gnome.gnome-keyring.enable = true;
    pulseaudio.enable = false;
    resolved.enable = false;
    libinput.enable = false;
    printing.enable = false;
  };

  powerManagement.cpuFreqGovernor = "performance";

  systemd = {
    targets = {
      sleep.enable = false;
      suspend.enable = false;
      hibernate.enable = false;
      hybrid-sleep.enable = false;
    };
    services = {
      # Override Ollama And Llama-CPP To Be Started Manually.
      #ollama.wantedBy = pkgs.lib.mkForce [ ];
      #llama-cpp.wantedBy = pkgs.lib.mkForce [ ];
      #};
    };
    user = {
      #settings.Manager = {
      #  "XDG_CURRENT_DESKTOP" = "niri:GNOME";
      #  "XDG_SESSION_TYPE" = "wayland";
      #  "NIXOS_OZONE_WL" = "1";
      #};
      services = {
        # Injects SOPS Keys Into Environment On Boot.
        sops-import = {
          enable = true;
          description = "Import SOPS-Rendered Environment Variables Into User Session";
          wantedBy = [ "graphical-session.target" "default.target" ];
          after = [ "sops-nix.service" ];
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
            ExecStart = pkgs.writeShellScript "sops-import-script" ''
              if [ -f /run/secrets/rendered/secrets.env ]; then
                set -a
                source /run/secrets/rendered/secrets.env
                set +a
                ${pkgs.systemd}/bin/systemctl --user import-environment $(${pkgs.coreutils}/bin/cut -d= -f1 /run/secrets/rendered/secrets.env)
                ${pkgs.dbus}/bin/dbus-update-activation-environment --systemd --all
              fi
            '';
          };
        };
        noctalia-shell = {
          description = "Noctalia Shell Bar Daemon";
          wantedBy = [ "graphical-session.target" ];
          wants = [ "graphical-session.target" ];
          after = [ "graphical-session.target" "dbus.socket" ];
          requires = [ "dbus.socket" ];
          serviceConfig = {
            Type = "simple";
            ExecStart = "${pkgs.noctalia-shell}/bin/noctalia-shell";
            Restart = "on-failure";
            RestartSec = 1;
            TimeoutStopSec = 10;
            Environment = "PATH=/run/current-system/sw/bin:/etc/profiles/per-user/%u/bin";
          };
        };
        #rusty-clip = {
        #  description = "Rusty-Clip Persistent Wayland Clipboard Daemon";
        #  wantedBy = [ "graphical-session.target" ];
        #  partOf = [ "graphical-session.target" ];
        #  serviceConfig = {
        #    ExecStart = "%h/.local/bin/rusty-clip daemon";
        #    Restart = "on-failure";
        #    RestartSec = "1s";
        #  };
        #};
        # Works For Sure, Original Service For Hyprland.
        #waybar = {
        #  unitConfig = {
        #    After = [ "graphical-session.target" ];
        #    Requires = [ "dbus.socket" ];
        #  };
        #  serviceConfig = {
        #    ExecStartPre = "${pkgs.glib}/bin/gdbus wait --system net.hadess.PowerProfiles";
        #  };
      };#};
    };
  };

  # NixOS VM sandbox.
  virtualisation = {
    vmVariant = {
      users.users = {
        ty.password = "test";
        root.password = "test";
      };
      virtualisation = {
        memorySize = 8192;
        cores = 8;
        qemu.options = [ "-device virtio-vga-gl -display gtk,gl=on" ];
      };
    };
    libvirtd = {
      enable = true;
      onBoot = "ignore";
      onShutdown = "shutdown";
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
      };
    };
    podman = {
      enable = true;
      dockerCompat = true;
    };
    containers.enable = true;
    oci-containers = {
      backend = "podman";
      containers = {
        #unsloth-proxy = {
        # image = "docker.io/unsloth/unsloth:latest";
        # autoStart = true;
        # ports = [ "4000:4000" ];
        # extraOptions = [ "--network=host" ];
        # cmd = [
        #   "unsloth run \
        #    -H 127.0.0.1 \
        #     -p 4000"
        #  ];
        #};
      };
    };
  };
  
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
