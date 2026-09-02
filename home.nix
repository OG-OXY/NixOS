#home.nix
{
  pkgs,
  ...
}:
{
  home = {
    stateVersion = "26.11";
    sessionPath = [
      "$HOME/.local/bin"
    ];
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
      ".config/tealdeer/config.toml".source = ./config/tealdeer/config.toml;
    };
  };

  xdg = {
    configFile = {
      "secretspec/config.toml".text = ''
        [defaults]
        provider = "keyring"
        profile = "default"
      '';
    };
    dataFile = {
      #
    };
  };

  systemd.user = {
    sessionVariables = {
      GITHUB_TOKEN = "$(cat /run/user/1000/secrets/github_token 2>/dev/null)";
    };
    services = {
      #waybar = {
      #  Unit = {
      #    After = [ "graphical-session.target" ];
      #    Requires = [ "dbus.socket" ];
      #  };
      #  Service = {
      #    ExecStartPre = "${pkgs.glib}/bin/gdbus wait --system net.hadess.PowerProfiles";
      #    Restart = "on-failure";
      #  };
      #  Install = {
      #    WantedBy = [ "graphical-session.target" ];
      #  };
      #};
      easyeffects = {
        Unit = {
          Description = "EasyEffects Audio Limiter & EQ";
          After = [ "pipewire.service" ];
        };
        Service = {
          ExecStart = "${pkgs.easyeffects}/bin/easyeffects --gapplication-service";
          Restart = "on-failure";
        };
        Install = {
          WantedBy = [ "graphical-session.target" ];
        };
      };
      #rbw-autounlock = {
      #  Unit =  {
      #    Description = "Securely unlock Bitwarden Vault on Hyprland Startup";
      #    After = [ "graphical-session.target" ];
      #    PartOf = [ "graphical-session.target" ];
      #  };
      #  Service = {
      #    Type = "oneshot";
      #    Environment = [
      #      "WAYLAND_DISPLAY=wayland-0"
      #      "DISPLAY=:0"
      #    ];
      #    ExecStart = "${pkgs.rbw}/bin/rbw unlock";
      #    RemainAfterExit = false;
      #  };
      #  Install = {
      #    WantedBy = [ "graphical-session.target" ];
      #  };
      #};
    };
  };

  imports = [
    ./homeModules.nix
  ];

  programs = {
    waybar = {
      enable = true;
      systemd.enable = true;
    };
    herdr.enable = true;
    devenv.enable = true;
    home-manager.enable = true;
  };
}
