{
  config,
  lib,
  pkgs,
  ...
}:
{
  # 1. Enable dconf system service (required for GTK4/libadwaita apps to read settings)
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
        };
      }
    ];
  };
  environment.systemPackages = [
    pkgs.papirus-icon-theme
  ];
}
