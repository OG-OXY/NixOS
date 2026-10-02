{
  ...
}:
{
  flake.nixosModules.portals = { pkgs, lib, ... }:
  {
    xdg.portal = {
      enable = true;
      configPackages = [ pkgs.niri ];
      extraPortals = [
        pkgs.xdg-desktop-portal-gnome
        pkgs.xdg-desktop-portal-gtk
        pkgs.xdg-desktop-portal-wlr
      ];
      wlr = {
        enable = true;
        settings = {
          screencast = {
            force_linear = true;
          };
        };
      };
      config = {
        common = {
          default = lib.mkForce [ "gtk" ];
          # Go Back To How Defaults Worked In <=1.7
          #default = "*";
        };
        #niri = lib.mkForce {
        #  default = [ "wlr" "gtk" ];
        #  "org.freedesktop.impl.portal.Screencast" = [ "wlr" ];
        #  "org.freedesktop.impl.portal.Screenshot" = [ "wlr" ];
        #  "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
        #};
        niri = {
          default = lib.mkForce [ "wlr" "gtk" ];
          "org.freedesktop.impl.portal.ScreenCast" = lib.mkForce [ "wlr" ];
          "org.freedesktop.impl.portal.Screenshot" = lib.mkForce [ "wlr" ];
          "org.freedesktop.impl.portal.FileChooser" = lib.mkForce [ "gtk" ];
          #"org.freedesktop.impl.portal.Access" = [ "gtk" ];
        };
        "niri:GNOME" = {
          default = lib.mkForce [ "gnome" "gtk" ];
          "org.freedesktop.impl.portal.ScreenCast" = lib.mkForce [ "gnome" ];
          "org.freedesktop.impl.portal.Screenshot" = lib.mkForce [ "gnome" ];
          "org.freedesktop.impl.portal.FileChooser" = lib.mkForce [ "gtk" ];
          #"org.freedesktop.impl.portal.Access" = [ "gtk" ];
        };
      };
    };
  };
}
