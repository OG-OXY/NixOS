{
  ...
}:
{
  flake.nixosModules.icons = { pkgs, ... }:
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
              icon-theme = "Papirus-Dark";
            };
            "org/GTK4/desktop/interface" = {
              color-scheme = "prefer-dark";
              cursor-theme = "Saturn";
              icon-theme = "hicolor";
            };

          };
        }
      ];
    };
    environment = {
      systemPackages = [
        pkgs.papirus-icon-theme
        pkgs.hicolor-icon-theme
      ];
      sessionVariables = {
        GTK_ICON_THEME = "Papirus-Dark";
        GTK_THEME = "Adwaita-dark";
        #GTK_THEME = "Papirus-Dark";
      };
      pathsToLink = [
        "/share/applications"
        "/share/icons"
      ];
    };
  };
}
