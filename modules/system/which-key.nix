{ config, lib, pkgs, ... }:

let
  cfg = config.programs.wlr-which-key;
  # Type definition for individual menu entries
  menuEntryType = lib.types.submodule {
    options = {
      key = lib.mkOption {
        type = lib.types.str;
        description = "Key binding to trigger the action.";
      };
      desc = lib.mkOption {
        type = lib.types.str;
        description = "Description displayed in the menu.";
      };
      cmd = lib.mkOption {
        type = lib.types.str;
        description = "Command or path to execute when selected.";
      };
    };
  };

  # Helper function that converts a menu definition into a binary package
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

  # Generate a package for each menu defined under options
  generatedMenuPackages = lib.mapAttrsToList mkMenuPackage cfg.menus;
in
{
  options.programs.wlr-which-key = {
    enable = lib.mkEnableOption "wlr-which-key system menus";
    settings = {
      anchor = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = "center";
        description = "Define Anchor to configure Menu position with string(e.g., center, top_left, bottom_right).";
      };
      margin = lib.mkOption {
        type = lib.types.nullOr lib.types.int;
        default = 10;
        description = "Set the Margin Size around the menu window with a nummber (integer, not a string)";
      };
      padding = lib.mkOption {
        type = lib.types.nullOr lib.types.int;
        default = 15;
        description = "Adjust Padding with a number (integer, not a string)";
      };
      border_width = lib.mkOption {
        type = lib.types.nullOr lib.types.int;
        default = 2;
        description = "Adjust Border Width with a number (integer, not a string)";
      };
      font = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Font family and size string for the menu text.";
      };
    };
    menus = lib.mkOption {
      type = lib.types.attrsOf (lib.types.listOf menuEntryType);
      default = {};
      description = "Attribute set of menu binary names to list of menu entries.";
      example = lib.literalExpression ''
        {
          menu-apps = [
            { key = "f"; desc = "Firefox"; cmd = "firefox"; }
            { key = "t"; desc = "Terminal"; cmd = "ghostty"; }
          ];
        }
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    # Expose the underlying binary and all generated menu wrappers system-wide
    environment.systemPackages = [ pkgs.wlr-which-key ] ++ generatedMenuPackages;
  };
}
