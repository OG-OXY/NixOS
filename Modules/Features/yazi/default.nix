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
      cwd = { fg = "#00d8b6", bold = true }
      hovered = { fg = "#161616", bg = "#2551fe", bold = true }
      preview_hovered = { underline = true }

      # Border styling
      border_symbol = "│"
      border_style  = { fg = "#45475a" }

      # Tab Bar
      tab_active   = { fg = "#161616", bg = "#00d8b6", bold = true }
      tab_inactive = { fg = "#e2e8f0", bg = "#23252e" }

      [status]
      separator_open  = ""
      separator_close = ""
      separator_style = { fg = "#23252e", bg = "#23252e" }

      # Mode badges (Normal / Select / Unset)
      mode_normal = { fg = "#161616", bg = "#00c853", bold = true }
      mode_select = { fg = "#161616", bg = "#fadb14", bold = true }
      mode_unset  = { fg = "#161616", bg = "#f02e6b", bold = true }

      # Permissions styling
      permissions_t = { fg = "#2551fe" }
      permissions_r = { fg = "#fadb14" }
      permissions_w = { fg = "#f06449" }
      permissions_x = { fg = "#00c853" }
      permissions_s = { fg = "#45475a" }

      # Filetype rules (THIS IS WHAT CONTROLS FILE COLORS IN YAZI)
      [filetype]
      rules = [
        # Directories -> Electric Blue
        { url = "*/", fg = "#2551fe", bold = true },
        
        # Executables -> Emerald Green
        { url = "*", is = "exec", fg = "#00c853", bold = true },
        
        # Symbolic links -> Bright Cyan
        { url = "*", is = "link", fg = "#00d8b6" },
        { url = "*", is = "orphan", fg = "#f02e6b" },
        
        # Plain / Regular files fallback -> Pure Crisp White
        { url = "*", fg = "#ffffff" }
      ]

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
      
      # Git file status colors
      unstaged = { fg = "#2551fe" }
      staged   = { fg = "#00c853" }
      deleted  = { fg = "#f06449", bold = true }
      added    = { fg = "#00c853" }
      untracked = { fg = "#fadb14" }
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
