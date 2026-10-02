{
  ...
}:
{
  flake.nixosModules.systemd = { pkgs, ... }:
  {
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
  };
}
