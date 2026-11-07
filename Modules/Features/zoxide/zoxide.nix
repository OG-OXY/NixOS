{
  ...
}:
{
  flake.nixosModules.zoxide = { ... }:
  {
    programs.zoxide = {
      enable = true;
      enableFishIntegration = true;
      enableNushellIntegration = true;
      options = [
        "--cmd cd"
      ];
    };
  };

  flake.homeModules.zoxide = { ... }:
  {
    programs.zoxide = {
      enable = true;
      enableFishIntegration = true;
      enableNushellIntegration = true;
      options = [
        "--cmd cd"
      ];
    };
  };
}
