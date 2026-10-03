{
  ...
}:
{
  flake.homeModules.fastfetch = { ... }:
  {
    programs.fastfetch = {
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
          #"de"
          "wm"
          #"wmtheme",
          #"theme"
          #"icons"
          #"font"
          #"cursor"
          "terminal"
          #"terminalfont"
          "cpu"
          "gpu"
          "memory"
          "swap"
          {
            type = "disk";
            format = "{1} / {2} ({3})";
            folder = "/:/boot:/home/ty/HDD:/home/ty/HDD/Storage:/home/ty/HDD/Pictures/Backup";
            key = "Disk ({1})";
          }
          "localip"
          #"battery"
          #"poweradapter"
          #"locale"
          #"break"
          "colors"
        ];
      };
    };
  };
}
