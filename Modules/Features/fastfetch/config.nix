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
          #width = 10;
          #height = 10;
          padding = {
            top = 2;
            bottom = 2;
            left = 2;
            right = 2;
          };
          color = {
            "1" = "blue";
            "2" = "cyan";
          };
        };
        display = {
          separator = " ➜ ";
          color = {
            keys = "blue";
            title = "blue";
          };
          key = {
            #width = "12";
            type = "string";
          };
          bar = {
            #width = "10";
            char = {
              elapsed = "■";
              total = "-";
            };
          };
          percent = {
            type = 2;
            color = {
              # Change module colors in reference to location of default colors, ie: set whats normally yellow to blue, whats green to red, etc.
              #green = "";
              #yellow = "";
              #red = "";
            };
          };
        };
        modules = [
          "title"
          {
            type = "separator";
            string = "───◆───";
            #string = "━━━━━━━━";
          }
          { type = "os"; key = " OS"; }
          { type = "host"; key = "󰌢 Host"; }
          { type = "kernel"; key = " Kernel"; }
          { type = "uptime"; key = " Uptime"; }
          { type = "packages"; key = "󰏖 Packages"; }
          { type = "shell"; key = " Shell"; }
          { type = "display"; key = "󰍹 Display"; }
          { type = "wm"; key = " WM"; }
          { type = "wmtheme"; key = "󰉼 WM Theme"; }
          { type = "theme"; key = "󰉼 Theme"; }
          { type = "icons"; key = "󰀻 Icons"; }
          #{ type = "font"; key = "󰛖 Font"; }
          #{ type = "cursor"; key = "󰆾 Cursor"; }
          { type = "terminal"; key = " Terminal"; }
          #{ type = "terminalfont"; key = "󰛖 Terminal Font"; }
          { type = "cpu"; key = " CPU"; }
          {
            type = "gpu";
            key = "󰾲 GPU";
            hideType = "integrated"; # Hides Raphael iGPU completely
            format = "{2}";
          }
          { type = "memory"; key = " Memory"; }
          { type = "swap"; key = "󰓡 Swap"; }
          {
            type = "disk";
            folders = "/";
            key = " ({name})";
            format = "{size-percentage-bar} {size-used} / {size-total}";
          }
          {
            type = "disk";
            folders = "/boot";
            key = " ({name})";
            format = "{size-percentage-bar} {size-used} / {size-total}";
            showRegular = true;
            showHidden = true;
            showExternel = true;
            showUnknown = true;
            showSubvolumes = true;
            showFS = "vfat";
            hideFS = "autofs";
          }
          {
            type = "disk";
            folders = "/home/ty/HDD";
            key = " ({name})";
            format = "{size-percentage-bar} {size-used} / {size-total}";
            hideFS = "autofs";
          }
          {
            type = "disk";
            folders = "/home/ty/HDD/Storage";
            key = " ({name})";
            format = "{size-percentage-bar} {size-used} / {size-total}";
            hideFS = "autofs";
          }
          {
            type = "disk";
            folders = "/home/ty/HDD/Pictures/Backup";
            key = " ({name})";
            format = "{size-percentage-bar} {size-used} / {size-total}";
            hideFS = "autofs";
          }
          #{
          #  type = "disk";
          #  key = " ({6})";
          #  format = "{1} / {2} ({3})";
          #  showHidden = true;
          #  showUnknown = true;
          #  showFS = "vfat";
          #  hideFS = "autofs";
          #  percent = {
          #    type = 3;
          #  };
          #  folders = [
          #    "/"
          #    "/boot"
          #    "/home/ty/HDD"
          #    "/home/ty/HDD/Storage"
          #    "/home/ty/HDD/Pictures/Backup"
          #  ];
          #}
          #"localip"
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
