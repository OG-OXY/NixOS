{
  ...
}:
{
  flake.nixosModules.wlr-which-keyModule = { config, pkgs, lib, ... }:
  let
    cfg = config.programs.wlr-which-key;

    menuEntryType = lib.types.submodule {
      options = {
        key = lib.mkOption { type = lib.types.str; description = "Key binding"; };
        desc = lib.mkOption { type = lib.types.str; description = "Description"; };
        cmd = lib.mkOption { type = lib.types.str; description = "Command to execute"; };
      };
    };

    mkMenuPackage = name: menuEntries:
      let
        configSet = lib.filterAttrs (_: v: v != null) {
          inherit (cfg.settings) anchor padding border_width font;
          margin_top = cfg.settings.margin;
          margin_bottom = cfg.settings.margin;
          margin_left = cfg.settings.margin;
          margin_right = cfg.settings.margin;
          menu = menuEntries;
        };
        configFile = pkgs.writeText "${name}-config.yaml" (builtins.toJSON configSet);
      in
      pkgs.writeShellScriptBin name ''
        exec ${pkgs.wlr-which-key}/bin/wlr-which-key ${configFile}
      '';

    generatedMenuPackages = lib.mapAttrsToList mkMenuPackage cfg.menus;
  in
  {
    # Option declarations for NixOS
    options.programs.wlr-which-key = {
      enable = lib.mkEnableOption "wlr-which-key system menus";
      settings = {
        anchor = lib.mkOption { type = lib.types.nullOr lib.types.str; default = "center"; };
        margin = lib.mkOption { type = lib.types.nullOr lib.types.int; default = 10; };
        padding = lib.mkOption { type = lib.types.nullOr lib.types.int; default = 15; };
        border_width = lib.mkOption { type = lib.types.nullOr lib.types.int; default = 2; };
        font = lib.mkOption { type = lib.types.nullOr lib.types.str; default = null; };
      };
      menus = lib.mkOption {
        type = lib.types.attrsOf (lib.types.listOf menuEntryType);
        default = { };
      };
    };

    # Config implementation + Default menu setups
    config = lib.mkIf cfg.enable {
      environment.systemPackages = [ pkgs.wlr-which-key ] ++ generatedMenuPackages;
    };
  };
}
