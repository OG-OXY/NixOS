#home.nix
{
  pkgs,
  config,  
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
        #GITHUB_TOKEN = { description = "Global GitHub Access token" }
        #GOOGLE_API_KEY = { description = "Google API Key for Aider" }
      '';
      ".config/tealdeer/config.toml".source = ./Config/Tealdeer/config.toml;
    };
  };

  xdg = {
    configFile = {
      "niri/config.kdl".source = config.lib.file.mkOutOfStoreSymlink "/home/ty/NixOS/Master/Config/Niri/config.kdl";
      "secretspec/config.toml".text = ''
        [defaults]
        provider = "bw"
        profile = "default"
      '';
    };
    dataFile = {
      #
    };
  };

  systemd.user = {
    sessionVariables = {
      #    
    };
    services = {
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
    };
  };

  programs = {
    devenv.enable = true;
    home-manager.enable = true;
  };
  
  imports = [
    ./homeModules.nix
  ];
}
