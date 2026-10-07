{
  ...
}:
{
  flake.nixosModules.yazi = { ... }:
  {
    programs.yazi = {
      enable = true;
      enableFishIntegration = true;
      enableNushellIntegration = true;
    };
  };
}
