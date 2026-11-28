# modules/jjui/jjui.nix
{
  ...
}:
{
  flake.homeModules.jjui = { ... }:
  {
    programs.jjui = {
      enable = true;
      package = null;
    };

    xdg.configFile."jjui/config.lua".source = ./config.lua;
  };
}
