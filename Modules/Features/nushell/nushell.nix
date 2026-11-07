{
  ...
}:
{
  flake.homeModules.nushell = { pkgs, ... }:
  let
    nushellConfig = builtins.readFile ./config.nu;
    # nushellEnv = ./env.nu;
  in
  {
    programs.nushell = {
      enable = true;
      envFile.text = ''
        #
      '';
      configFile.text = ''
        ${nushellConfig}
      '';
      plugins =
      let
        nu = pkgs.nushellPlugins;
      in
      [
        nu.formats
        nu.polars
        nu.query
        # nu.highlight
      ];
    };
  };
  flake.nixosModules.nushell = { ... }:
  {
    programs.nushell.enable = true;
  };
}
