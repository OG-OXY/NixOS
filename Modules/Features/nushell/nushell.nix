{
  inputs,
  ...
}:
{
  flake.homeModules.nushell = { pkgs, config, ... }:
  let
    nushellConfig = builtins.readFile ./config.nu;
    nushellEnv = builtins.readFile ./env.nu;
    nushellNu = ./nu;
    # nushellNuScripts = "${inputs.nuscripts}";
  in
  {
    programs.nushell = {
      enable = true;
      envFile.text = ''
        ${nushellEnv}
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
      ".config/nushell/nu".source = config.lib.file.mkOutOfStoreSymlink "${nushellNu}";
      ".config/nushell/nu_scripts".source = config.lib.file.mkOutOfStoreSymlink "${inputs.nuscripts}";
      ".config/nushell/vendors/autoload".source = config.lib.file.mkOutOfStoreSymlink "/run/current-system/sw/share/nushell/vendor/autoload";
    };
  };
  flake.nixosModules.nushell = { ... }:
  {
    programs.nushell.enable = true;
  };
}
