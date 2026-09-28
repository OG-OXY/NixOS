{
  ...
}:
{
  flake.nixosModules.zoxideModule = { pkgs, config, lib, ... }:
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
      # 1. Ensure the binary is globally available
      environment.systemPackages = [ pkgs.zoxide ];
  
      # 2. Wire up native Fish integration if enabled
      programs.fish.interactiveShellInit = lib.mkIf cfg.enableFishIntegration ''
        # Initialized via native NixOS zoxide module
        status --is-interactive; and source (${lib.getExe pkgs.zoxide} init fish ${lib.concatStringsSep " " cfg.options})
      '';
    };
  };
}
