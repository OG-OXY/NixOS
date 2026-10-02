{
  ...
}:
{
  flake.nixosModules.wlr-portal-conf = { pkgs, ... }:
  let
    wlrPortalConf = pkgs.writeText "wlr-portal.conf" ''
      [screencast]
      force_linear = true
    '';
  in
  {
    systemd.tmpfiles.rules = [
      "d /home/ty/.config/xdg-desktop-portal-wlr 0755 ty users -"
      "L+ /home/ty/.config/xdg-desktop-portal-wlr/config 0644 ty users - ${wlrPortalConf}"
    ];
  };
}
