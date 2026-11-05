{
  ...
}:
{
  flake.homeModules.imv = { ... }:
  {
    programs.imv = {
      enable = true;
      settings = {
        options = {
          recursive = false;
          supress_default_binds = false;
          background = "000000";
          scaling_mode = "full";
        };
        binds = {
          "<Escape>" = "quit";
          "d" = "close";
          "r" = "reset";
        };
      };
    };
  };
}
