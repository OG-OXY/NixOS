{ pkgs, ... }:

let
  # Determine libgbm package cleanly depending on Nixpkgs version
  gbmPkg = pkgs.mesa-libgbm or pkgs.libgbm or pkgs.mesa;

  runtimeLibs = with pkgs; [
    wayland
    wayland-protocols
    libxkbcommon
    libinput
    udev
    dbus
    pixman
    mesa
    gbmPkg        # Explicitly provides libgbm.so
    libdrm
    seatd
    fontconfig
    vulkan-loader
    libglvnd
    egl-wayland
    xorg.libX11
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

  packages = with pkgs; [
    pkg-config
    clang
    lld
    gdb
    foot
  ] ++ runtimeLibs;

  enterShell = ''
    export RUSTFLAGS="${rustLinkFlags}"
    export LIBRARY_PATH="${libPath}"
    export LD_LIBRARY_PATH="${libPath}"
    export PKG_CONFIG_PATH="${pkgs.lib.makeSearchPathOutput "dev" "lib/pkgconfig" runtimeLibs}:${pkgs.lib.makeSearchPathOutput "out" "lib/pkgconfig" runtimeLibs}:${pkgs.lib.makeSearchPath "share/pkgconfig" runtimeLibs}"

    echo "🦀 Rust Wayland Compositor Dev Environment Ready"
  '';
}
