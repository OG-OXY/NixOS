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
    settings = lib.importTOML ../../Config/Starship/starship-root.toml;
  };
}
