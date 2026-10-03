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
          opacity = 0.90;
          blur = true;
          padding = { x = 0; y = 0; };
          decorations = "none"; # Removes ugly OS titlebars on Wayland
        };

        font = {
          size = 11.5;
          normal = {
            family = "JetBrainsMono Nerd Font";
            style = "Bold";
          };
        };

        # Catppuccin Mocha Palette
        colors = {
          primary = {
            background = "#1e1e2e";
            foreground = "#cdd6f4";
          };
          cursor = {
            text = "#1e1e2e";
            cursor = "#f5e0dc";
          };
          normal = {
            black   = "#45475a";
            red     = "#f38ba8";
            green   = "#a6e3a1";
            yellow  = "#f9e2af";
            blue    = "#89b4fa";
            magenta = "#f5c2e7";
            cyan    = "#94e2d5";
            white   = "#bac2de";
          };
        };
      };
    };
  };
}
