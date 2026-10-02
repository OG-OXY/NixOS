{
  lib,
  ...
}:
{
  home = {
    username = "ty";
    homeDirectory = "/home/ty";
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = lib.importTOML ../Config/Starship/starship.toml;
  };
}
