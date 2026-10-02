{
  ...
}:
{
  flake.nixosModules.yaziModule = { pkgs, lib, config, ... }:
  let
    cfg = config.programs.yazi;

    # Native yazi.toml configuration (bypassing manual tmpfiles hacks)
    #yaziConfig = pkgs.writeText "yazi-config" ''
    #  [manager]
    #  show_hidden = true
    #  sort_by = "mtime"
    #  sort_sensitive = false
    #  sort_reverse = true
    #'';

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
      
      environment.systemPackages = lib.optionals cfg.enableFishIntegration [ yaziFishFunction ];

      # 2. Link the configuration file natively
        #systemd.tmpfiles.rules = [
        #  "d /home/ty/.config/yazi 0755 ty users -"
        #  "L+ /home/ty/.config/yazi/yazi.toml 0644 ty users - ${yaziConfig}"
        #];
    };
  };
}
