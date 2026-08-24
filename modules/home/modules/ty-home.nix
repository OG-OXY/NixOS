{
  lib,
  ...
}:
{
  home = {
    username = "ty";
    homeDirectory = "/home/ty";
  };

  imports = [ ../ty.nix ];

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = lib.importTOML ../../config/starship/starship.toml;
  };
}
