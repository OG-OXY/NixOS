{ pkgs, ... }:

let
  gbmPkg = pkgs.mesa-libgbm or pkgs.libgbm or pkgs.mesa;

  # Combined superset of runtime libraries for both the window manager and system daemons
  runtimeLibs = [
    gbmPkg
    pkgs.wayland
    pkgs.wayland-protocols
    pkgs.libxkbcommon
    pkgs.libinput
    pkgs.libdisplay-info
    pkgs.udev
    pkgs.dbus
    pkgs.pixman
    pkgs.mesa
    pkgs.libdrm
    pkgs.seatd
    pkgs.fontconfig
    pkgs.vulkan-loader
    pkgs.libglvnd
    pkgs.egl-wayland
    pkgs.xorg.libX11
  ];

  rustLinkFlags = pkgs.lib.concatMapStrings (path: " -L native=${path}/lib") runtimeLibs;
  libPath = pkgs.lib.makeLibraryPath runtimeLibs;
in
{
  languages.rust = {
    enable = true;
    channel = "stable";
    components = [
      "rustc"
      "cargo"
      "clippy"
      "rustfmt"
      "rust-analyzer"
      "rust-src"
    ];
  };

  packages = [
    pkgs.pkg-config
    pkgs.bacon
    pkgs.clang
    pkgs.lld
    pkgs.gdb
    pkgs.foot
  ] ++ runtimeLibs;

  enterShell = ''
    export RUSTFLAGS="${rustLinkFlags}"
    export LIBRARY_PATH="${libPath}"
    export LD_LIBRARY_PATH="${libPath}"
    export PKG_CONFIG_PATH="${pkgs.lib.makeSearchPathOutput "dev" "lib/pkgconfig" runtimeLibs}:${pkgs.lib.makeSearchPathOutput "out" "lib/pkgconfig" runtimeLibs}:${pkgs.lib.makeSearchPath "share/pkgconfig" runtimeLibs}"
    echo "🦀 Master Rust Workspace Ready (Vigspa, Rusty-Clip, & Tools)"
  '';
}
