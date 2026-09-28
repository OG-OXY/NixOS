{
  inputs,
  ...
}:
{
  flake.nixosModules.wlr-which-key = { config, pkgs, lib, ... }:
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
    config = lib.mkMerge [
      (lib.mkIf cfg.enable {
        environment.systemPackages = [ pkgs.wlr-which-key ] ++ generatedMenuPackages;
      })

      {
        programs.wlr-which-key = {
          enable = true;
          settings = {
            anchor = "center";
            font = "JetBrainsMono NFM 12";
          };
          menus = {
            warp = [
              { key = "w"; desc = "Normal Mode"; cmd = "${pkgs.warpd}/bin/warpd --normal"; }
              { key = "h"; desc = "Hint Mode"; cmd = "${pkgs.warpd}/bin/warpd --hint"; }
              { key = "q"; desc = "Quadrant Mode"; cmd = "${pkgs.warpd}/bin/warpd --grid"; }
            ];
            apps = [
              { key = "l"; desc = "Launcher"; cmd = "${pkgs.noctalia-shell}/bin/noctalia-shell ipc call launcher toggle"; }
              { key = "h"; desc = "Herdr"; cmd = "${pkgs.ghostty}/bin/ghostty -e ${pkgs.herdr}/bin/herdr"; }
              { key = "g"; desc = "Ghostty"; cmd = "${pkgs.ghostty}/bin/ghostty"; }
              { key = "y"; desc = "Yazi"; cmd = "${pkgs.ghostty}/bin/ghostty -e ${pkgs.fish}/bin/fish -i -C 'y'"; }
              { key = "z"; desc = "Zen-Browser"; cmd = "${inputs.zen-browser.packages.${pkgs.system}.default}/bin/zen-beta"; }
              { key = "o"; desc = "Obsidian"; cmd = "${pkgs.obsidian}/bin/obsidian /home/ty/Notes/Vault"; }
              { key = "n"; desc = "Obsidian (New Note)"; cmd = "xdg-open 'obsidian://new?vault=Vault&name=New%20Note'"; }
              { key = "v"; desc = "Vesktop"; cmd = "${pkgs.vesktop}/bin/vesktop"; }
              { key = "s"; desc = "OBS-Studio"; cmd = "${pkgs.obs-studio}/bin/obs"; }
              { key = "b"; desc = "Bitwarden"; cmd = "${pkgs.bitwarden-desktop}/bin/bitwarden"; }
              { key = "e"; desc = "EasyEffects"; cmd = "${pkgs.easyeffects}/bin/easyeffects"; }
            ];
          };
        };
      }
    ];
  };
}
