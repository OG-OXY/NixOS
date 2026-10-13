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
          #
        '';
        configFile.text = ''
          $env.config = {
            show_banner: false
            table: {
              mode: rounded
            }
          }
          alias nsh = help commands | where command_type == built-in | select name category description | explore
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
