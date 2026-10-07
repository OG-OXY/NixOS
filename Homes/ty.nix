{
  lib,
  ...
}:
{
  home = {
    username = "ty";
    homeDirectory = "/home/ty";
  };
  programs.starship.settings = lib.importTOML ../Config/Starship/starship.toml;
}
