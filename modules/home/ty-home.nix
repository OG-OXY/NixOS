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
    settings = lib.importTOML ../../config/starship/starship.toml;
  };
}
