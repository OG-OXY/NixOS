{
  config,
  pkgs,
  ...
}:
{
  boot = {
    kernelPackages = pkgs.linuxPackages_cachyos-lto-znver4;

    loader = {
      grub = {
        enable = true;
        efiSupport = true;
        useOSProber = true;
        device = "nodev";
        configurationLimit = 30;
      };
      efi.canTouchEfiVariables = true;
    };

    initrd = {
      kernelModules = [ "amdgpu" ];
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

    kernelParams = [
      "processor.max_cstate=0"
      "amd_idle.max_cstate=0"
      "amd_iommu=on"
      "iommu=pt"
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

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
  };

  users.users = {
    root = {
      isNormalUser = false;
      shell = pkgs.fish;
    };
    ty = {
      isNormalUser = true;
      home = "/home/ty";
      shell = pkgs.fish;
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

  services.gpg-agent = {
    enable = true;
    enableExtraSocket = true;
    enableSshSupport = false;
    defaultCacheTtl = 28800;
    maxCacheTtl = 86400;
    pinentry.package = pkgs.pinentry-gnome3;
    extraConfig = ''
      allow-loopback-pinentry
    '';
  };

  # Embedded Home Manager settings for ty (SINGLE programs = block lives here)
  home-manager.users.ty = {
    home = {
      stateVersion = "26.11";
      sessionPath = [ "$HOME/.local/bin" ];
      sessionVariables = {
        EDITOR = "nvf";
        VISUAL = "nvf";
      };
      file = {
        "NixOS/secretspec.toml".text = ''
          [project]
          name = "global-dev"
          revision = "1.0"

          [profiles.default]
          GITHUB_TOKEN = { description = "Global GitHub Access token" }
          GOOGLE_API_KEY = { description = "Google API Key for Aider" }
        '';
      };
    };

    xdg.configFile = {
      "secretspec/config.toml".text = ''
        [defaults]
        provider = "keyring"
        profile = "default"
      '';
    };

    systemd.user.sessionVariables = {
      PINENTRY_USER_DATA = "gtk";
    };

    programs = {
      waybar.enable = true;

      fish = {
        enable = true;
        functions = {
          gback = {
            description = "Safely undo the last Git commit but keep file changes.";
            body = ''
              if not git rev-parse --is-inside-work-tree >/dev/null 2>&1
                echo (set_color red)"❌ Error: Not a git repository!"(set_color normal)
                return 1
              end
              echo (set_color yellow)"⏪ Undoing last commit safely (keeping modifications)..."(set_color normal)
              git reset --soft HEAD~1
              echo (set_color green)"✨ Done! Check 'git status' to see your uncommitted files."(set_color normal)
            '';
          };
          j = {
            description = "tell jj to grab secrets from secretspec.";
            body = ''
              secretspec run -- jj $argv
            '';
          };
          gh = {
            description = "tell github-cli to grab secrets from secretspec";
            body = ''
              secretspec run -- gh $argv
            '';
          };
          ss = {
            description = "For Grabbing secrets.";
            body = ''
              secretspec run -- $argv
            '';
          };
        };

        shellAbbrs = {
          su = "doas fish";
          ls = "ls -a";
          cds = "cd ~/NixOS/nixos";
          ga = "git add -A";
          gc = "git commit -m \"\"";
          gp = "git push -u origin master";
          gpf = "git push -u --force origin master";
          jb = "jj bookmark";
        };
      };

      atuin = {
        enable = true;
        enableFishIntegration = true;
        settings = {
          ai.enabled = true;
          dialect = "us";
          timezone = "local";
          auto_sync = true;
          show_preview = true;
          exit_mode = "return-original";
          word_jump_mode = "emacs";
          show_numeric_shortcuts = true;
          show_help = true;
          show_tabs = true;
          enter_accept = true;
          command_chaining = true;
          sync.records = true;
          tmux.enabled = false;
        };
      };

      fastfetch = {
        enable = true;
        settings = {
          logo = {
            source = "nixos";
            type = "auto";
            color = {
              "1" = "blue";
              "2" = "cyan";
            };
            padding = {
              top = 0;
              left = 0;
              right = 2;
            };
          };
          display = {
            separator = "➜ ";
            color = {
              keys = "blue";
              title = "blue";
            };
            percent = {
              type = 3;
            };
          };
          modules = [
            "title"
            "separator"
            "os"
            "host"
            "kernel"
            "uptime"
            "packages"
            "shell"
            "display"
            "wm"
            "terminal"
            "cpu"
            "gpu"
            "memory"
            "swap"
            "disk"
            "localip"
            "colors"
          ];
        };
      };

      ghostty = {
        enable = true;
        enableFishIntegration = true;
        settings = {
          theme = "Aurora";
          background-opacity = 1.0;
          adjust-cell-height = "-10%";
          adjust-cell-width = "-10%";
          cursor-style = "block";
          shell-integration-features = "no-cursor";
          font-family = "JetBrainsMono Nerd Font Bold";
          font-family-bold = "JetBrainsMono Nerd Font ExtraBold";
          font-family-italic = "JetBrainsMono Nerd Font Bold Italic";
          font-family-bold-italic = "JetBrainsMono Nerd Font ExtraBold Italic";
          font-size = 22;
          font-feature = [
            "liga"
            "calt"
          ];
        };
      };

      zoxide = {
        enable = true;
        enableFishIntegration = true;
      };

      jujutsu = {
        enable = true;
        settings = {
          user = {
            name = "Ty";
            email = "ogoxy.yt@gmail.com";
          };
          git = {
            auto-local-bookmark = true;
            push-revset = [ "master" ];
            default-push = "master";
          };
          signing = {
            sign-all = true;
            backend = "ssh";
            key = "~/.ssh/id_ed25519.pub";
          };
          ui = {
            editor = "nvf";
            paginate = "never";
          };
          fsmonitor = {
            backend = "watchman";
          };
          revsets = {
            immutable-heads = "tracked_remote_bookmarks()";
          };
          aliases = {
            s = [ "status" ];
            l = [
              "log"
              "-r"
            ];
          };
        };
      };

      gh = {
        enable = true;
        settings = {
          git_protocol = "ssh";
          prompt = "enabled";
        };
        gitCredentialHelper = {
          enable = true;
        };
      };

      yazi = {
        enable = true;
        enableFishIntegration = true;
        package = null;
        settings = {
          manager = {
            show_hidden = true;
            sort_by = "mtime";
            sort_sensitive = false;
            sort_reverse = true;
          };
          opener = {
            edit = [
              {
                run = "nvf \"$@\"";
                block = true;
                desc = "Edit";
              }
            ];
          };
        };
      };
    };
  };

  specialisation = {
    hardened = {
      configuration = {
        system.nixos.label = "NIXOS-HARDENED";
        boot = {
          loader.grub.configurationName = "NIXOS-HARDENED";
          kernelPackages = pkgs.linuxPackages_hardened;
        };

        hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.legacy_580;

        boot.kernel.sysctl = {
          "kernel.kptr_restrict" = 2;
          "kernel.dmesg_restrict" = 1;
          "fs.protected_hardlinks" = 1;
          "fs.protected_symlinks" = 1;
          "vm.unprivileged_userfaultfd" = 0;
        };

        services.kmscon = {
          enable = true;
          hwaccel = true;
          fonts = [
            {
              name = "JetBrainsMono Nerd Font";
              package = pkgs.nerd-fonts.jetbrains-mono;
            }
          ];
          extraOptions = "--term xterm-256color";
        };

        environment.systemPackages = [
          pkgs.aircrack-ng
          pkgs.hcxdumptool
          pkgs.hcxtools
          pkgs.wifite
          pkgs.kismet
          pkgs.nmap
          pkgs.masscan
          pkgs.rustscan
          pkgs.netcat
          pkgs.tcpdump
          pkgs.wireshark
          pkgs.tshark
          pkgs.dnsenum
          pkgs.enum4linux
          pkgs.metasploit
          pkgs.sqlmap
          pkgs.hydra
          pkgs.gobuster
          pkgs.ffuf
          pkgs.nikto
          pkgs.burpsuite
          pkgs.john
          pkgs.hashcat
          pkgs.cewl
          pkgs.binwalk
          pkgs.strace
          pkgs.ltrace
          pkgs.htop
        ];
      };
    };
  };
}
