{
  ...
}:
{
  flake.homeModules.alacritty = { ... }:
  {
    programs.alacritty = {
      enable = true;
      package = null;
      settings = {
        window = {
          opacity = 1.0;
          blur = true;
          padding = { x = 0; y = 0; };
          decorations = "none"; # Removes ugly OS titlebars on Wayland
          startup_mode = "Windowed";
        };
        keyboard = {
          bindings = [
            { key = "Super"; mode = "Vi | AppCursor | AppKeypad"; action = "None"; }
          ];
        };

        font = {
          size = 20;
          normal = {
            family = "JetBrainsMono Nerd Font";
            style = "Bold";
          };
        };
        colors = {
          primary = {
            background = "#161616"; # Pure dark background
            foreground = "#fadb14"; # Saturated yellow baseline text
          };
        
          cursor = {
            text = "#161616";
            cursor = "#f06449";
          };
        
          selection = {
            text = "#161616";
            background = "#00d8b6";
          };
        
          # Prevent Alacritty from applying an ugly tint/dim shift when focused/unfocused
          dim = {
            black   = "#161616";
            red     = "#f06449";
            green   = "#00c853";
            yellow  = "#fadb14";
            blue    = "#2551fe";
            magenta = "#f02e6b";
            cyan    = "#00d8b6";
            white   = "#e2e8f0";
          };
        
          normal = {
            black   = "#161616"; # Keep black aligned with background
            red     = "#f06449";
            green   = "#00c853";
            yellow  = "#fadb14"; # Pure yellow
            blue    = "#2551fe";
            magenta = "#f02e6b";
            cyan    = "#00d8b6";
            white   = "#e2e8f0";
          };
        
          bright = {
            black   = "#45475a";
            red     = "#f06449";
            green   = "#00e676";
            yellow  = "#fadb14";
            blue    = "#2551fe";
            magenta = "#f02e6b";
            cyan    = "#00d8b6";
            white   = "#ffffff";
          };
          indexed_colors = [
            { index = 16; color = "#f06449"; }
            { index = 17; color = "#f02e6b"; }
            { index = 18; color = "#23252e"; }
            { index = 19; color = "#313244"; }
            { index = 20; color = "#45475a"; }
            { index = 21; color = "#bac2de"; }
          ];
        };
      };
    };
  };
}
