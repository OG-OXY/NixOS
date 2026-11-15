{
  ...
}:
{
  flake.nixosModules.nushellModule = { pkgs, lib, config, ... }:
  let
    cfg = config.programs.nushell;
  in
  {
    config = lib.mkIf cfg.enable {
      environment = {
        systemPackages = [
          pkgs.nushell
          (pkgs.runCommand "ghostty-nushell-config" {} ''
          mkdir -p $out/share/nushell/vendor/autoload
          ln -s ${pkgs.ghostty}/share/ghostty/shell-integration/nushell/vendor/autoload/ghostty.nu \
            $out/share/nushell/vendor/autoload/ghostty.nu
        '')
        ];
        pathsToLink = [ "/share/nushell" ];
      };
    };
  };
}

# (pkgs.runCommand "nu_scripts" {} ''
#   mkdir -p $out/share/nushell
#   cp -r ${inputs.nu_scripts} $out/share/nushell/nu_scripts
# '')
