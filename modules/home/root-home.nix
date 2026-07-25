{
  lib,
  ...
}:
{
  home = {
    username = "root";
    homeDirectory = "/root";
  };

  imports = [ ../../home.nix ];

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = lib.importTOML ./starship/starship-root.toml;
  };
}
