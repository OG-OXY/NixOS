{
  ...
}:
{
  flake.nixosModules.yaziModule = { pkgs, lib, config, ... }:
  let
    cfg = config.programs.yazi;

    yazi-full-border = pkgs.fetchFromGitHub {
      owner = "yazi-rs";
      repo = "plugins";
      rev = "6229767f7fef39a2a78f5cee9122cc4dfb43f327";
      hash = "sha256-crZPqubzH7re43f9XiOIpIcHrTNikgBftFh7eP1YLH4=";
      sparseCheckout = [ "full-border.yazi" ];
    };

    yazi-git = pkgs.fetchFromGitHub {
      owner = "yazi-rs";
      repo = "plugins";
      rev = "6229767f7fef39a2a78f5cee9122cc4dfb43f327";
      hash = "sha256-+qHfMxL+zxkToK/Urd3flpA/I1bxUOSPYoyj2sUGcO0=";
      sparseCheckout = [ "git.yazi" ];
    };

    yazi-chmod = pkgs.fetchFromGitHub {
      owner = "yazi-rs";
      repo = "plugins";
      rev = "6229767f7fef39a2a78f5cee9122cc4dfb43f327";
      hash = "sha256-pAaZvXaX8MFCafdznGkQQeVwSAaPqBjft+OCKYoTvXs=";
      sparseCheckout = [ "chmod.yazi" ];
    };
    
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
        "L+ /home/ty/.config/yazi/plugins/full-border.yazi 0755 ty users - ${yazi-full-border}/full-border.yazi"
        "L+ /home/ty/.config/yazi/plugins/git.yazi 0755 ty users - ${yazi-git}/git.yazi"
        "L+ /home/ty/.config/yazi/plugins/chmod.yazi 0755 ty users - ${yazi-chmod}/chmod.yazi"
        "L+ /home/ty/.config/yazi/yazi.toml 0644 ty users - ${yaziToml}"
        "L+ /home/ty/.config/yazi/init.lua 0644 ty users - ${yaziInit}"
        "L+ /home/ty/.config/yazi/keymap.toml 0644 ty users - ${yaziKeymap}"
        "L+ /home/ty/.config/yazi/theme.toml 0644 ty users - ${yaziTheme}"
      ];
    };
  };
}
