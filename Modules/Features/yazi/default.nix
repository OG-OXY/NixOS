{
  inputs,
  ...
}:
{
  flake.nixosModules.yaziModule = { pkgs, lib, config, ... }:
  let
    cfg = config.programs.yazi;

    # Standalone Fish function package (replicates what Home Manager does behind the scenes)
    yaziFishFunction = pkgs.runCommand "yazi-fish-function" {} ''
      mkdir -p $out/share/fish/vendor_functions.d
      cat << 'EOF' > $out/share/fish/vendor_functions.d/y.fish
      function y
          set -l tmp (mktemp -t "yazi-cwd.XXXXX")
          command yazi $argv --cwd-file="$tmp"
          if read cwd <"$tmp"; and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
              builtin cd -- "$cwd"
          end
          rm -f -- "$tmp"
      end
      EOF
    '';
    
    yaPack = inputs.ya-packs;
    
    yaziToml = pkgs.writeText "yazi.toml" ''
      [mgr]
      show_hidden = true
      sort_by = "alphabetical"
      sort_sensitive = false
      sort_reverse = false
      linemode = "size"
      [[plugin.prepend_fetchers]]
      url   = "*"
      run   = "git"
      group = "git"
      [[plugin.prepend_fetchers]]
      url   = "*/"
      run   = "git"
      group = "git"
    '';

    # Native Lua initialization file
    yaziInit = pkgs.writeText "init.lua" ''
      require("full-border"):setup()
      require("starship"):setup()
      require("git"):setup {
          order = 1500,
      }
    '';

    # Fixed keymap configuration (Corrected syntax: manager.prepend_keymap)
    yaziKeymap = pkgs.writeText "keymap.toml" ''
      [[mgr.prepend_keymap]]
      on   = [ "c", "h" ]
      run  = "plugin chmod"
      desc = "Chmod selected files"
    '';

    # Merged theme configuration with all signs defined
    yaziTheme = pkgs.writeText "theme.toml" ''
      [git]
      unknown_sign   = " "
      unstaged_sign  = "-S"
      staged_sign    = "S"
      deleted_sign   = "-D"
      clean_sign     = "✔"
      ignored_sign   = "I"
      untracked_sign = "-T"
      added_sign     = "+S"
      updated_sign   = "U"
      unstaged = { fg = "blue" }
      deleted  = { fg = "red", bold = true }
    '';
  in
  {
    options.programs.yazi = {
      enableFishIntegration = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable Fish shell integration wrapper for yazi";
      };
    };
    
    config = lib.mkIf config.programs.yazi.enable {
      
      environment = {
        systemPackages = lib.optionals cfg.enableFishIntegration [ yaziFishFunction ];
        #etc = {
        #  "xdg/yazi/plugins/full-border.yazi".source = "${yazi-full-border}/full-border.yazi";
        #  "xdg/yazi/plugins/git.yazi".source = "${yazi-git}/git.yazi";
        #  "xdg/yazi/plugins/chmod.yazi".source = "${yazi-chmod}/chmod.yazi";
        #  "xdg/yazi/init.lua".source = "${yaziInit}/init.lua";
        #  "xdg/yazi/keymap.toml".source = "${yaziKeymap}/keymap.toml";
        #};
      };
      
      # 2. Link the configuration file natively
      systemd.tmpfiles.rules = [
        "d /home/ty/.config/yazi 0755 ty users -"
        "d /home/ty/.config/yazi/plugins 0755 ty users -"
        "L+ /home/ty/.config/yazi/plugins/full-border.yazi 0755 ty users - ${yaPack}/full-border.yazi"
        "L+ /home/ty/.config/yazi/plugins/git.yazi 0755 ty users - ${yaPack}/git.yazi"
        "L+ /home/ty/.config/yazi/plugins/chmod.yazi 0755 ty users - ${yaPack}/chmod.yazi"
        "L+ /home/ty/.config/yazi/plugins/smart-filter.yazi 0755 ty users - ${yaPack}/smart-filter.yazi"
        "L+ /home/ty/.config/yazi/plugins/mount.yazi 0755 ty users - ${yaPack}/mount.yazi"
        "L+ /home/ty/.config/yazi/plugins/starship.yazi 0755 ty users - ${inputs.ya-ship}"
        "L+ /home/ty/.config/yazi/yazi.toml 0644 ty users - ${yaziToml}"
        "L+ /home/ty/.config/yazi/init.lua 0644 ty users - ${yaziInit}"
        "L+ /home/ty/.config/yazi/keymap.toml 0644 ty users - ${yaziKeymap}"
        "L+ /home/ty/.config/yazi/theme.toml 0644 ty users - ${yaziTheme}"
      ];
    };
  };
}
