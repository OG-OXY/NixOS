{
  ...
}:
{
  flake.nixosModules.themes = { pkgs, lib, ... }:
  let
    gtkIni = pkgs.writeText "gtk-settings.ini" ''
      [Settings]
      gtk-cursor-theme-name = Saturn
      gtk-cursor-theme-size = 32
      gtk-icon-theme-name = Papirus-Dark
      gtk-theme-name = Adwaita-dark
      gtk-application-prefer-dark-theme = 1
      gtk-font-name = Inter 12
    '';
  in
  {
    # 1. Enable dconf system service (required for GTK4/libadwaita apps to read settings)
    qt = {
      enable = true;
      platformTheme = "gnome";
      style = "adwaita-dark";
    };
    programs.dconf = {
      enable = true;
      profiles.user.databases = [
        {
          settings = {
            "org/gnome/desktop/interface" = {
              color-scheme = "prefer-dark";
              cursor-theme = "Saturn";
              cursor-size = lib.gvariant.mkInt32 32;
              icon-theme = "Papirus-Dark";
              gtk-theme = "Adwaita-dark";
              font-name = "Inter 12";
            };
          };
        }
      ];
    };
    environment = {
      systemPackages = [
        pkgs.papirus-icon-theme
        pkgs.adwaita-icon-theme
        pkgs.hicolor-icon-theme
      ];
      sessionVariables = {
        GTK_ICON_THEME = "Papirus-Dark";
        GTK_THEME = "Adwaita-dark";
      };
      pathsToLink = [
        "/share/applications"
        "/share/icons"
      ];
    };
    systemd.tmpfiles.rules = [
      "d /home/ty/.config/gtk-3.0/ 0775 ty users -"
      "d /home/ty/.config/gtk-4.0/ 0775 ty users -"
      "L+ /home/ty/.config/gtk-3.0/settings.ini 0644 ty users - ${gtkIni}"
      "L+ /home/ty/.config/gtk-4.0/settings.ini 0644 ty users - ${gtkIni}"
    ];
  };
}
