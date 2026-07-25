{
  lib,
  ...
}:
{
  home = {
    username = "ty";
    homeDirectory = "/home/ty";
  };

  imports = [ ../../home.nix ];

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = lib.importTOML ./starship/starship.toml;
  };
}
