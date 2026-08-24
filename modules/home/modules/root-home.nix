{
  lib,
  ...
}:
{
  home = {
    username = "root";
    homeDirectory = "/root";
  };

  imports = [ ../ty.nix ];

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = lib.importTOML ../../config/starship/starship-root.toml;
  };
}
