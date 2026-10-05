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
            top = 2;
            bottom = 2;
            left = 2;
            right = 2;
          };
        };
        display = {
          separator = " ➜ ";
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
          {
            type = "separator";
            string = "───◆───";
          }
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
          {
            type = "gpu";
            hideType = "integrated"; # Hides Raphael iGPU completely
            format = "{2}";
          }
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
          {
            type = "colors";
            key = " ";
            symbol = "block";
            paddingLeft = 0;
            block = {
              range = [ 0 15 ];
              width = 3;
            };
          }
        ];
      };
    };
  };
}
