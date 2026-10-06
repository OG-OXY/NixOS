{
  ...
}:
{
  flake.nixosModules.services = { pkgs, ... }:
  {
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
      ollama = {
        enable = false;
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
        enable = false;
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
      kmscon = {
        enable = true;
        config = {
          hwaccel = true;
          colors = "#121212,#ff4433,#33cc55,#ffaa22,#2255ff,#cc33ff,#00e5ff,#e0e0e0,#555555,#ff6655,#55ff77,#ffcc44,#4477ff,#ff55ff,#55ffff,#ffffff";
        };
      };
      dbus.enable = true;
      gnome.gnome-keyring.enable = true;
      power-profiles-daemon.enable = true;
      tailscale.enable = true;
      resolved.enable = false;
      pulseaudio.enable = false;
      libinput.enable = false;
      printing.enable = false;
    };
  };
}
