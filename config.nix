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
      dates = "daily";
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
        "uinput"
        "plugdev"
        "audio"
        "gamemode"
        "i2c"
        "libvirtd"
        "kvm"
        "vboxusers"
        "wireshark"
        "tcpdump"
      ];
    };
  };

  # Networking PKGS + Parameters
  networking = {
    hostName = "nixos";
    nameservers = [ 
      "1.1.1.1"
      "1.0.0.1"
      "9.9.9.9"
    ];
    networkmanager = {
      enable = true;
      wifi = {
        backend = "iwd";
        powersave = false;
      };
      dns = "dnsmasq";
      #insertNameservers = [
      #  "1.1.1.1"
      #  "1.0.0.1"
      #  "9.9.9.9"
      #];
      ensureProfiles = {
        environmentFiles = [ config.sops.templates."WIFI_PSK.env".path ];
        profiles = {
          "Home-WIFI" = {
            connection = {
              id = "Home-WIFI";
              type = "wifi";
              autoconnect = true;
            };
            wifi = {
              ssid = "JOSH3881";
              bssid = "7C:9A:54:AF:D7:22";
              interface-name = "wlan0";
              mode = "infrastructure";
              band = "bg";
              powersave = 2;
            };
            wifi-security = {
              key-mgmt = "wpa-psk";
              psk = "$WIFI_PSK"; #SOPS secret
            };
            ipv4 = {
              method = "auto";
              ignore-auto-dns = true;
            };
            ipv6 = {
              addr-gen-mode = "default";
              method = "auto";
              ignore-auto-dns = true;
            };
          };
        };
      };
    };
    firewall = {
      allowedTCPPorts = [ 22 ];
      trustedInterfaces = [ "tailscale0" ];
    };
    wireless = {
      enable = false;
      iwd = {
        enable = true;
        settings = {
          General = {
            EnableNetworkConfiguration = false;
          };
          Rank = {
            BandModifier5GHz = 0.0;
            "BandModifier2.4GHz" = 10.0;
          };
        };
      };
    };
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
        group = "users";
        mode = "0400";
      };
      "GOOGLE_API_KEY" = {
        owner = "ty";
        group = "users";
        mode = "0400";
      };
      "GEMINI_API_KEY" = {
        owner = "ty";
        group = "users";
        mode = "0400";
      };
      "WIFI_PSK" = {
        owner = "root";
        group = "root";
        mode = "0400";
      };
      "bw_client_id" = {
        owner = "ty";
        group = "users";
        mode = "0400";
      };
      "bw_client_secret" = {
        owner = "ty";
        group = "users";
        mode = "0400";
      };
    };
    templates = {
      "secrets.env" = {
        owner = "ty";
        group = "users";
        mode = "0400";
        content = ''
          GITHUB_TOKEN=${config.sops.placeholder.GITHUB_TOKEN}
          GOOGLE_API_KEY=${config.sops.placeholder.GOOGLE_API_KEY}
          GEMINI_API_KEY=${config.sops.placeholder.GOOGLE_API_KEY}
          BW_CLIENTID=${config.sops.placeholder.bw_client_id}
          BW_CLIENTSECRET=${config.sops.placeholder.bw_client_secret}
        '';
      };
      "WIFI_PSK.env" = {
        owner = "root";
        group = "root";
        mode = "0400";
        content = ''
          WIFI_PSK=${config.sops.placeholder.WIFI_PSK}
        '';
      };
    };
  };
  
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-gnome
    ];
    config = {
      common = {
        default = [ "gtk" ];
        # Go Back To How Defaults Worked In <=1.7
        #default = "*";
      };
      hyprland = {
        default = [ "hyprland" "gtk" ];
      };
      niri = {
        default = [ "gnome" "gtk" ];
      };
    };
    #configPackages = [ pkgs.gnome-session ];
  };

  # Install PKGS With System Parameters.
  programs = {
    # Custom NixOS Modules I WROTE MYSELF
    wlr-which-key = {
      enable = true;
      settings = {
        anchor = "center";
        font = "JetBrainsMono NFM 12";
      };
      menus = {
        warp = [
          {
            key = "w";
            desc = "Normal Mode (Vim h/j/k/l)";
            cmd = "${pkgs.warpd}/bin/warpd --normal";
          }
          {
            key = "h";
            desc = "Hint Mode (Click Target)";
            cmd = "${pkgs.warpd}/bin/warpd --hint";
          }
          {
            key = "q";
            desc = "Quadrant Mode (Grids)";
            cmd = "${pkgs.warpd}/bin/warpd --grid";
          }
        ];
        apps = [
          {
            key = "l";
            desc = "Launcher";
            cmd = "${pkgs.noctalia-shell}/bin/noctalia-shell ipc call launcher toggle";
          }
          {
            key = "g";
            desc = "Ghostty";
            cmd = "${pkgs.ghostty}/bin/ghostty";
          }
          {
            key = "t";
            desc = "Tmux";
            cmd = "${pkgs.ghostty}/bin/ghostty -e ${pkgs.fish}/bin/fish -i -C 'tmux new-session -A -s main'";
          }
          {
            key = "y";
            desc = "Yazi";
            cmd = "${pkgs.ghostty}/bin/ghostty -e ${pkgs.fish}/bin/fish -i -C 'y'";
          }
          {
            key = "z";
            desc = "Zen-Browser";
            cmd = "${inputs.zen-browser.packages.${pkgs.system}.default}/bin/zen-beta";
          }
          {
            key = "o";
            desc = "Obsidian";
            cmd = "${pkgs.obsidian}/bin/obsidian /home/ty/Notes/Vault";
          }
          {
            key = "n";
            desc = "Obsidian (New Note)";
            cmd = "xdg-open 'obsidian://new?vault=Vault&name=New%20Note'";
          }
          {
            key = "v";
            desc = "Vesktop";
            cmd = "${pkgs.vesktop}/bin/vesktop";
          }
          {
            key = "b";
            desc = "Bitwarden";
            cmd = "${pkgs.bitwarden-desktop}/bin/bitwarden";
          }
          {
            key = "e";
            desc = "EasyEffects";
            cmd = "${pkgs.easyeffects}/bin/easyeffects";
          }
        ];
      };
    };
    warpd = {
      enable = true;
      settings = {
        buttons = "space m n";
        #hint_exit = "";
        #grid_exit = "";
        #hint_activation_key = "A-M-h";
        #grid_activation_key = "A-M-g";
        speed = 500;
        cursor_color = "0000f6";
        #hint_chars = "asfqwcbnyui";
      };
    };
    # Native NixOS Modules
    #hyprland = {
    #  enable = true;
    #  withUWSM = true;
    #  xwayland.enable = true;
    #};
    uwsm = {
      enable = true;
      waylandCompositors = {
        niri = {
          prettyName = "Niri";
          comment = "Niri Scrollable Tiling Compositor Managed by UWSM.";
          binPath = "${pkgs.niri}/bin/niri";
        };
          #hyprland = {
          #  prettyName = "Hyprland";
          #  comment = "An Intelligent Wayland Compositor Managed by UWSM.";
          #  binPath = "${pkgs.hyprland}/bin/hyprland";
          #};
      };
    };
    niri = {
      enable = true;
      package = pkgs.niri;
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
    fish.enable = true;
    zoxide.enable = true;
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
      XCURSOR_THEME = "Saturn";
      XCURSOR_SIZE = "32";
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
      WLR_NO_HARDWARE_CURSORS = "0";
      #HYPRCURSOR_SIZE = "32";
      XCURSOR_THEME = "Saturn";
      XCURSOR_SIZE = "32";
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
      #pkgs.waybar
      #pkgs.mako
      #pkgs.wofi
      pkgs.ghostty
      pkgs.yazi
      #pkgs.hyprpaper
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
      pkgs.ffmpeg-full
      pkgs.obs-studio
      #pkgs.hyprshot
      pkgs.mpv
      pkgs.mpd
      pkgs.imv
      #pkgs.hyprpicker
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
      #pkgs.delicious-sddm-theme
      pkgs.quickshell
      pkgs.kdePackages.qtdeclarative
      pkgs.kdePackages.qtsvg
      pkgs.kdePackages.qt5compat
      pkgs.kdePackages.kwin
      pkgs.noctalia-shell
      pkgs.xwayland-satellite
      pkgs.nixfmt
      pkgs.jq
      #pkgs.sway
      pkgs.ventoy
      pkgs._7zz
      pkgs.poppler-utils
      pkgs.imagemagick
      pkgs.resvg
      pkgs.qpwgraph
      pkgs.helvum
      # Wifi Monitor Tools
      pkgs.iw
      pkgs.wavemon
      pkgs.obsidian
      # Config dump.
      pkgs.repomix
    ]
    ++ [
      inputs.zen-browser.packages.${pkgs.system}.default
      inputs.nvf.packages.${pkgs.system}.default
      #inputs.llm-agents.packages.${pkgs.system}.default
      #pkgs.cudaPackages.cuda_nvcc
      #pkgs.cudaPackages.cudatoolkit
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
          cursor = {
            theme = "Saturn";
            size = 32;
          };
          appearance = {
            wallpaper = "/home/ty/NixOS/Master/Config/Theme/Wpapers/gruvbox-rainbow-nix.png";
            blur = true;
          };
        };
      };
      # BROKEN ASS MODULE HENCE THE MKFORCE GARBAGE.
      #regreet = {
      #  enable = true;
      #  cageArgs = lib.mkForce [
      #    "-s"
      #    "-m"
      #    "last"
      #  ];
      #  settings = {
      #    background = {
      #      path = lib.mkForce "/etc/nixos/wallpaper.png";
      #      fit = lib.mkForce "Cover";
      #    };
      #    theme = {
      #      package = lib.mkForce pkgs.gnome-themes-extra;
      #      name = lib.mkForce "Adwaita-dark";
      #    };
      #    iconTheme = {
      #      package = lib.mkForce pkgs.adwaita-icon-theme;
      #      name = lib.mkForce "Adwaita";
      #    };
      #    cursorTheme = {
      #      package = lib.mkForce pkgs.bibata-cursors;
      #      name = lib.mkForce "Bibata-Modern-Classic";
      #    };
      #    GTK = {
      #      theme_name = lib.mkForce "Adwaita-dark";
      #      icon_theme_name = lib.mkForce "Adwaita";
      #      cursor_theme_name = lib.mkForce "Bibata-Modern-Classic";
      #      font_name = lib.mkForce "Inter 11";
      #    };
      #    commands = {
      #      reboot = lib.mkForce [
      #        "doas"
      #        "reboot"
      #        "now"
      #      ];
      #      shutdown = lib.mkForce [
      #        "doas"
      #        "poweroff"
      #      ];
      #    };
      #    #extraCss = ''
      #    #'';
      #  };
      #};
      # SDDM Is Fucking Dogshit Enough Said.
      #sddm = {
      #  enable = true;
      #  wayland.enable = true;
      #  # Uses Qt6 for a crisp native Wayland greeter
      #  package = pkgs.kdePackages.sddm; 
      #  theme = "delicious"; # Or leave default / custom theme
      #  settings = {
      #    Theme = {
      #      Current = "delicious";
      #      ThemeDir = "run/current-system/sw/share/sddm/themes";
      #    };
      #    Wayland = {
      #      CompositorCommand = "${pkgs.kdePackages.kwin}/bin/kwin_wayland --no-lockscreen --no-global-shortcuts";
      #    };
      #    #General = {
      #    #  InputMethod = "";
      #    #};
      #  };
      #};
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
    dbus.enable = true;
    kmscon.enable = true;
    tailscale.enable = true;
    gnome.gnome-keyring.enable = false;
    power-profiles-daemon.enable = true;
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
      # Override Ollama and Llama-CPP Started Manually.
      #ollama.wantedBy = pkgs.lib.mkForce [ ];
      #llama-cpp.wantedBy = pkgs.lib.mkForce [ ];
      # Old No Longer Using SDDM. Was A Test.
      #sddm.environment = {
      #  WLR_NO_HARDWARE_CURSORS = "0";
      #};
    };
    user.services = {
      # Injects SOPS Keys Into Environment On Boot.
      sops-import = {
        enable = true;
        description = "Import sops-rendered environment variables into systemd user session";
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
      # Noctalia-Shell Systemd Service For Niri That Is Supposed To Not Start For Hyprland.
      niri-bar = {
        enable = true;
        description = "Noctalia Shell for UWSM Managed Niri compositor";
        wantedBy = [ "niri.target" ];
        unitConfig = {
          After = [ "niri.target" "dbus.socket" ];
          PartOf = [ "niri.target" ];
          Conflicts = [ "hyprland.target" ];
        };
        serviceConfig = {
          ExecStart = "${pkgs.noctalia-shell}/bin/noctalia-shell";
          Restart = "on-failure";
        };
      };
      # Not Sure If This Works Either
      #noctalia-shell = {
      #  enable = true;
      #  description = "Noctalia Shell for UWSM Managed Niri compositor";
      #  wantedBy = [ "wayland-session@niri.target" ];
      #  unitConfig = {
      #    After = [ "wayland-session@niri.target" "dbus.socket" ];
      #    PartOf = [ "wayland-session@niri.target" ];
      #    Conflicts = [ "wayland-session@hyprland.target" ];
      #  };
      #  serviceConfig = {
      #    ExecStart = "${pkgs.noctalia-shell}/bin/noctalia-shell";
      #    Restart = "on-failure";
      #  };
      #};
      # Hopefully This Creates Intended Effect And Doesnt Launch With Niri But Does For Hyprland.
      waybar = {
        enable = false;
        description = "Waybar for UWSM Managed Hyprland";
        wantedBy = [ "hyprland.target" ];
        unitConfig = {
          PartOf = [ "hyprland.target" ];
          After = [ "hyprland.target" ];
          Conflicts = [ "niri.target" ];
        };
        serviceConfig = {
          ExecStartPre = "${pkgs.glib}/bin/gdbus wait --system net.hadess.PowerProfiles";
          ExecStart = "${pkgs.waybar}/bin/waybar";
          Restart = "on-failure";
        };
      };
      # Didnt Create Intended Effect.
      #waybar = {
      #  enable = true;
      #  description = "Waybar for UWSM Managed Hyprland";
      #  wantedBy = [ "wayland-session@hyprland.target" ];
      #  unitConfig = {
      #    PartOf = [ "wayland-session@hyprland.target" ];
      #    After = [ "wayland-session@hyprland.target" ];
      #    Conflicts = [ "wayland-session@niri.target" ];
      #  };
      #  serviceConfig = {
      #    ExecStartPre = "${pkgs.glib}/bin/gdbus wait --system net.hadess.PowerProfiles";
      #    ExecStart = "${pkgs.waybar}/bin/waybar";
      #    Restart = "on-failure";
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
      #};
      # Doesnt Work Probably Not Needed Anyways With SOPS + AGE Now.
      #rbw-autounlock = {
      #  description = "Securely unlock Bitwarden Vault on Hyprland Startup";
      #  wantedBy = [ "graphical-session.target" "default.target" ];
      #  unitConfig = {
      #    After = [ "graphical-session.target" "dbus.socket" ];
      #    #PartOf = [ "wayland-session@hyprland-uwsm.target" ];
      #    #After = [ "graphical-session.target" ];
      #    #PartOf = [ "graphical-session.target" ];
      #  };
      #  serviceConfig = {
      #    Type = "oneshot";
      #    #Environment = [
      #    #  "WAYLAND_DISPLAY=wayland-0"
      #    #  "DISPLAY=:0"
      #    #];
      #    ExecStart = "${pkgs.rbw}/bin/rbw unlock";
      #    RemainAfterExit = false;
      #  };
      #};
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
