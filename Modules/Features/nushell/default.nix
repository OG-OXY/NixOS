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
        systemPackages = [ pkgs.nushell ];
        pathsToLink = [ "/share/nushell" ];
      };
    };
  };
}
