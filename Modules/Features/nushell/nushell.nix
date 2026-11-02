{
  ...
}:
{
  flake.homeModules.nushell = { ... }:
  let
    nushellConfig = builtins.readFile ./config.nu;
    # nushellEnv = ./nushell-env.nu;
  in
  {
    programs = {
      nushell = {
        enable = true;
        envFile.text = ''
          #
        '';
        configFile.text = ''
          ${nushellConfig}
        '';
      };
      carapace = {
        enable = true;
        enableNushellIntegration = true;
        enableFishIntegration = true;
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
    programs.nushell.enable = true;
  };
}
