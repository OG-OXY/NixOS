{
  ...
}:
{
  flake.homeModules.nushell = { pkgs, config, ... }:
  let
    nushellConfig = builtins.readFile ./config.nu;
    nushellEnv = builtins.readFile ./env.nu;
    nushellScripts = ./nu;
  in
  {
    programs.nushell = {
      enable = true;
      envFile.text = ''
        $env.NU_LIB_DIRS = [
            ${nushellEnv}
            ($nu.default-config-dir | path join scripts)
        ]
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
    home.file = {
      ".config/nushell/scripts".source = config.lib.file.mkOutOfStoreSymlink "${nushellScripts}";
    };
  };
  flake.nixosModules.nushell = { ... }:
  {
    programs.nushell.enable = true;
  };
}
