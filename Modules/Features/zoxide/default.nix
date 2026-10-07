{
  ...
}:
{
  flake.nixosModules.zoxideModule = { pkgs, lib, config, ... }:
  let
    cfg = config.programs.zoxide;
    cfgOptions = lib.concatStringsSep " " cfg.options;
    zoxideNushellInit = pkgs.runCommand "zoxide-nushell-config.nu" {} ''
      mkdir -p $out/share/nushell/vendor/autoload
      ${lib.getExe cfg.package} init nushell ${cfgOptions} > $out/share/nushell/vendor/autoload/zoxide.nu
    '';
  in
  {
    options.programs.zoxide = {
      options = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        example = [ "--cmd cd" ];
        description = "Additional flags passed to zoxide init.";
      };
      enableNushellIntegration = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable Nushell integration for Zoxide";
      };
    };
  
    config = lib.mkIf cfg.enable {
      programs.zoxide.flags = cfg.options;
      environment = {
        systemPackages = [
          (if cfg.enableNushellIntegration then zoxideNushellInit else null)
        ];
      };
    };
  };
}
