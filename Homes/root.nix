{
  lib,
  ...
}:
{
  home = {
    username = "root";
    homeDirectory = "/root";
  };
  programs.starship.settings = lib.importTOML ../Config/Starship/starship-root.toml;
}
