{
  ...
}:
{
  flake.nixosModules.warpd = { ... }:
  {
    programs.warpd = {
      enable = true;
      settings = {
        buttons = "space m n";
        #hint_exit = "";
        #grid_exit = "";
        #hint_activation_key = "A-M-h";
        #grid_activation_key = "A-M-g";
        speed = 400;
        cursor_color = "0000f6";
        #hint_chars = "asfqwcbnyui";
      };
    };
  };
}
