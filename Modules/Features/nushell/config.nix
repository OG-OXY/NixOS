{
  ...
}:
{
  flake.homeModules.nushell = { ... }:
  {
    programs = {
      nushell = {
        enable = true;
        envFile.text = ''
          $env.STARSHIP_SHELL = "nu"
        '';
        configFile.text = ''
          $env.config = {
            show_banner: false
            table: {
              mode: rounded
            }
          }
        '';
      };
      carapace = {
        enable = true;
        enableNushellIntegration = true;
      };
      starship.enableNushellIntegration = true;
      atuin.enableNushellIntegration = true;
      direnv = {
        enable = true;
        enableNushellIntegration = true;
        enableFishIntegration = true;
      };
    };
  };
  flake.nixosModules.nushell = { ... }:
  {
    programs.nushell = {
      enable = true;
    };
  };
}
