{
  inputs,
  ...
}:
{
  flake.homeModules.home = { pkgs, config, ... }:
  {
    home = {
      stateVersion = "26.11";
      sessionPath = [
        "$HOME/.local/bin"
      ];
      sessionVariables = {
        EDITOR = "hx";
        VISUAL = "glow";
      };
      activation.removeLegacyNixArtifacts = ''
        rm -f $HOME/.nix-profile $HOME/.steampath
      '';
      file = {
      };
    };

    xdg = {
      configFile = {
        "niri/config.kdl".source = config.lib.file.mkOutOfStoreSymlink "/home/ty/NixOS/Master/Config/Niri/config.kdl";
        "tealdeer/config.toml".source = config.lib.file.mkOutOfStoreSymlink "/home/ty/NixOS/Master/Config/Tealdeer/config.toml";
        "secretspec/config.toml".source = config.lib.file.mkOutOfStoreSymlink "home/ty/NixOS/Master/Config/Secretspec/config.toml";
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
      carapace = {
        enable = true;
        enableNushellIntegration = true;
        enableFishIntegration = true;
      };
      direnv = {
        enable = true;
        enableNushellIntegration = true;
        enableFishIntegration = true;
      };
      home-manager.enable = true;
    };
  };
}
