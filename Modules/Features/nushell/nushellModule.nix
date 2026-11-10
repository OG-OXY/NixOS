{
  inputs,
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
          (pkgs.runCommand "nu_scripts" {} ''
            mkdir -p $out/share/nushell
            cp -r ${inputs.nuscripts} $out/share/nushell/nu_scripts
          '')
        ];
        pathsToLink = [ "/share/nushell" ];
      };
    };
  };
}
