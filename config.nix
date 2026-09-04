#config.nix
{
  pkgs,
  config,
  lib,
  inputs,
  self,
  ...
}:
{
  imports = [
    ./systemModules.nix
  ];

  # Bootloader + GRUB parameters.
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
    };
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      useOSProber = true;
      configurationLimit = 30;
    };
  };

  # NIX-PKG-Manager parameters.
  nix = {
    settings = {
      auto-optimise-store = true;
      download-buffer-size = 536870912;
      max-substitution-jobs = 128;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
    # Garbage collection.
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 5d";
    };
  };

  # User account.
  security = {
    polkit.enable = true;
    rtkit.enable = true;
    doas = {
      enable = true;
      extraRules = [
        {
          users = [ "ty" ];
          noPass = true;
          keepEnv = true;
        }
      ];
    };
    sudo = {
      enable = true;
      extraRules = [
        {
          groups = [ "wheel" ];
          commands = [
            {
              command = "ALL";
              options = [ "NOPASSWD" ];
            }
          ];
        }
      ];
    };
    pam.services = {
      login = {
        enableGnomeKeyring = false;
        enableKwallet = false;
      };
    };
  };

  # User parameters.
  users = {
    mutableUsers = true;
    users.root.shell = pkgs.fish;
    users.ty = {
      shell = pkgs.fish;
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "networkmanager"
        "video"
        "render"
        "input"
        "audio"
        "seat"
        "seatd"
        "docker"
        "libvirtd"
        "vboxusers"
        "wireshark"
        "tcpdump"
      ];
    };
  };

  # Networking PKGS + parameters.
  networking = {
    hostName = "nixos";
    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
      dns = "dnsmasq";
      ensureProfiles = {
        environmentFiles = [ config.sops.secrets.WIFI_HOME_PSK.path ];
        profiles = {
          "home-wifi" = {
            connection = {
              id = "WIFI";
              type = "wifi";
              autoconnect = true;
            };
            wifi = {
              ssid = "JOSH3881";
              mode = "infrastructure";
            };
            wifi-security = {
              key-mgmt = "wpa-psk";
              psk = "$WIFI_HOME_PSK"; # References the sops secret variable
            };
          };
        };
      };
    };
    firewall = {
      allowedTCPPorts = [ 22 ];
      trustedInterfaces = [ "tailscale0" ];
    };
    wireless.enable = false;
  };

  sops = {
    defaultSopsFile = "/home/ty/NixOS/secrets.yaml";
    defaultSopsFormat = "yaml";
    validateSopsFiles = false;
    age = {
      keyFile = "/home/ty/.config/sops/age/keys.txt";
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    };
    secrets = {
      "GITHUB_TOKEN" = {
        owner = "ty";
        mode = "0444";
      };
      "GOOGLE_API_KEY" = {
        owner = "ty";
        mode = "0444";
      };
      "WIFI_HOME_PSK" = {
        owner = "ty";
        mode = "0444";
      };
      "bw_client_id" = {
        owner = "ty";
        mode = "0444";
      };
      "bw_client_secret" = {
        owner = "ty";
        mode = "0444";
      };
    };
    templates = {
      "bitwarden-env".content = ''
        BW_CLIENTID="${config.sops.placeholder.bw_client_id}"
        BW_CLIENTSECRET="${config.sops.placeholder.bw_client_secret}"
      '';
    };
  };
  
  # Install PKGS with system parameters.
  programs = {
    hyprland = {
      enable = true;
      withUWSM = true;
      xwayland.enable = true;
    };
    uwsm = {
      enable = true;
      waylandCompositors.niri = {
        prettyName = "Niri";
        binPath = "${pkgs.niri}/bin/niri";
      };
    };
    niri = {
      enable = true;
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    fish.enable = true;
    zoxide.enable = true;
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
    virt-manager.enable = true;
    nano.enable = false;
  };

  fonts = {
    packages = [
      pkgs.nerd-fonts.jetbrains-mono
      pkgs.nerd-fonts.fira-code
      pkgs.font-awesome
      pkgs.inter
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [
          "JetBrainsMono Nerd Font"
          "FiraCode Nerd Font"
          "Inter"
        ];
        sansSerif = [
          "Inter"
          "Font Awesome 6 Free"
          "Font Awesome 6 Brands"
          "JetBrainsMono Nerd Font"
          "FiraCode Nerd Font"
        ];
        serif = [
          "Inter"
          "Font Awesome 6 Free"
          "Font Awesome 6 Brands"
          "JetBrainsMono Nerd Font"
          "FiraCode Nerd Font"
        ];
      };
      #localConf = ''
      #
      #'';
    };
  };

  # Install system PKGS.
  environment = {
    shells = [ pkgs.fish ];
    variables = {
      CPATH = "/run/current-system/sw/include";
      LIBRARY_PATH = "/run/current-system/sw/lib";
      #VST_PATH = "$HOME/.vst:$HOME/.wine/drive_c/Program Files/Steinburg/VstPlugins";
      #VST3_PATH = "$HOME/.vst3:$HOME/.wine/drive_c/Program Files/Common Files/VST3";
    };
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
      #AQ_DRM_DEVICES = "/dev/dri/by-path/pci-0000:01:00.0-card";
      LIBVA_DRIVER_NAME = "nvidia";
      XDG_SESSION_TYPE = "wayland";
      GBM_BACKEND = "nvidia-drm";
      #__GLX_VENDOR_LIBRARY_NAME = "nvidia";
      NVD_BACKEND = "direct";
      QT_QPA_PLATFORM = "wayland;xcb";
      SDL_VIDEO_DRIVER = "wayland,x11";
      PROTON_ENABLE_WAYLAND = "1";
      PROTON_ENABLE_NVAPI = "1";
      ENABLE_GAMESCOPE_WSI = "1";
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "$HOME/.steam/root/compatibilitytools.d";
      HYPRCURSOR_SIZE = "24";
      XCURSOR_SIZE = "24";
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
    systemPackages = [
      pkgs.stdenv.cc
      pkgs.binutils
      pkgs.gnumake
      pkgs.cmake
      pkgs.pkg-config
      pkgs.gdb
      pkgs.valgrind
      pkgs.hyprpolkitagent
      pkgs.watchman
      pkgs.pinentry-qt
      pkgs.noctalia-shell
      pkgs.waybar
      pkgs.mako
      pkgs.wofi
      pkgs.ghostty
      pkgs.yazi
      pkgs.hyprpaper
      pkgs.bitwarden-desktop
      pkgs.vesktop
      pkgs.pavucontrol
      pkgs.pipewire
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
      pkgs.obs-studio
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
      pkgs.mpd
      pkgs.mpv
      pkgs.imv
      pkgs.hyprshot
      pkgs.hyprpicker
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
      pkgs.herdr
      pkgs.llama-cpp
      pkgs.aider-chat
      pkgs.fd
      pkgs.bun
      pkgs.devenv
      pkgs.starship
      pkgs.atuin
      pkgs.libnotify
      pkgs.aria2
      pkgs.monero-cli
      pkgs.easyeffects
      pkgs.quickshell
      pkgs.kdePackages.qtdeclarative
      pkgs.nixfmt
      pkgs.jq
    ]
    ++ [
      inputs.zen-browser.packages.${pkgs.system}.default
      inputs.nvf.packages.${pkgs.system}.default
      inputs.llm-agents.packages.${pkgs.system}.default
      #inputs.woomer.packages.${pkgs.system}.default
      #pkgs.cudaPackages.cuda_nvcc
      #pkgs.cudaPackages.cudatoolkit
    ];
    etc = {
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
    config.common.default = "*";
  };

  hardware = {
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
      regreet = {
        enable = true;
        cageArgs = [
          "-s"
          "-m clone"
        ];
        settings = {
          background = {
            path = "/etc/nixos/wallpaper.png";
            fit = "Cover";
          };
          #theme = {
          #  package = "";
          #  name = "";
          #};
          #iconTheme = {
          #  package = "";
          #  name = "";
          #};
          #cursorTheme = {
          #  package = "";
          #  name = "";
          #};
          #GTK = {
          #  theme_name = "Adwaita-dark";
          #  icon_theme_name = "Adwaita";
          #  cursor_theme_name = "";
          #  font_name = lib.mkDefault "Inter 11";
          #};
          commands = {
            reboot = [
              "doas"
              "reboot"
              "now"
            ];
            shutdown = [
              "doas"
              "shutdown"
              "now"
            ];
          };
          #extraCss = ''
          #'';
        };
      };
    };
    dbus.enable = true;
    greetd.enable = true;
    kmscon.enable = true;
    tailscale.enable = true;
    gnome.gnome-keyring.enable = false;
    power-profiles-daemon.enable = true;
    hardware.openrgb = {
      enable = true;
      package = pkgs.openrgb-with-all-plugins;
      motherboard = "amd";
    };
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
    ollama = {
      enable = true;
      package = (pkgs.ollama-cuda.override { }).overrideAttrs (oldAttrs: {
        cmakeFlags = (oldAttrs.cmakeFlags or [ ]) ++ [
          "-DCMAKE_CUDA_ARCHITECTURES=61"
        ];
      });
      environmentVariables = {
        CUDA_VISIBLE_DEVICES = "0";
        OLLAMA_GPU_OVERHEAD = "512";
      };
    };
    llama-cpp = {
      enable = true;
      settings = {
        hf-repo = "Qwen/Qwen2.5-Coder-32B-Instruct-GGUF";
        hf-file = "qwen2.5-coder-32b-instruct-q4_k_m.gguf";
        host = "0.0.0.0";
        port = 8012;
        jinja = true;
        flash-attn = "on";
        ctx-size = 32768;
        cache-type-k = "q8_0";
        cache-type-v = "q8_0";
        n-gpu-layers = 40;
      };
      package =
        (pkgs.llama-cpp.override {
          cudaSupport = true;
        }).overrideAttrs
          (oldAttrs: {
            cmakeFlags = (oldAttrs.cmakeFlags or [ ]) ++ [
              "-DCMAKE_CUDA_ARCHITECTURES=61"
            ];
          });
    };
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
      ollama.wantedBy = pkgs.lib.mkForce [ ];
      llama-cpp.wantedBy = pkgs.lib.mkForce [ ];
    };
    user.services = {
      waybar = {
        unitConfig = {
          After = [ "graphical-session.target" ];
          Requires = [ "dbus.socket" ];
        };
        serviceConfig = {
          ExecStartPre = "${pkgs.glib}/bin/gdbus wait --system net.hadess.PowerProfiles";
        };
      };
      rbw-autounlock = {
        description = "Securely unlock Bitwarden Vault on Hyprland Startup";
        wantedBy = [ "wayland-session@Hyprland-uwsm.target"];
        unitConfig = {
          After = [ "wayland-session@Hyprland-uwsm.target" "dbus.socket" ];
          PartOf = [ "wayland-session@Hyprland-uwsm.target" ];
          #After = [ "graphical-session.target" ];
          #PartOf = [ "graphical-session.target" ];
        };
        serviceConfig = {
          Type = "oneshot";
          #Environment = [
          #  "WAYLAND_DISPLAY=wayland-0"
          #  "DISPLAY=:0"
          #];
          ExecStart = "${pkgs.rbw}/bin/rbw unlock";
          RemainAfterExit = false;
        };
      };
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
}
