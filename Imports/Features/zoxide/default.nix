{
  ...
}:
{
  flake.nixosModules.zoxideModule = { config, lib, ... }:
  let
    cfg = config.programs.zoxide;
  in
  {
    options.programs.zoxide = {
      options = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        example = [ "--cmd cd" ];
        description = "Additional flags passed to zoxide init.";
      };
    };
  
    config = lib.mkIf cfg.enable {
      programs.zoxide.flags = cfg.options;
    };
  };
}
