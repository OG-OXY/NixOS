{ pkgs, ... }:

{
  languages.rust = {
    enable = true;
    channel = "stable";
  };

  packages = [
    pkgs.pkg-config
    pkgs.wayland
    pkgs.wayland-protocols
    pkgs.libxkbcommon
    pkgs.libinput
    pkgs.udev
    pkgs.dbus
  ];
}
