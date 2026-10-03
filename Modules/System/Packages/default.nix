{
  inputs,
  ...
}:
{
  flake.nixosModules.systemPackages = { pkgs, ... }:
  {
    environment.systemPackages = let
      Cuda = pkgs.cudaPackages;
      Kde = pkgs.kdePackages;
      Gst = pkgs.gst_all_1;
      Gsr = pkgs.gpu-screen-recorder.override {
        ffmpeg = pkgs.ffmpeg_6; # Uses NVENC API 13.0 compatible headers
      };
    in
    [
      pkgs.stdenv.cc
      pkgs.binutils
      pkgs.gnumake
      pkgs.cmake
      pkgs.pkg-config
      pkgs.gdb
      pkgs.valgrind
      pkgs.polkit_gnome
      pkgs.watchman
      pkgs.pinentry-qt
      pkgs.xwayland-satellite
      pkgs.noctalia-shell
      pkgs.ghostty
      pkgs.alacritty
      pkgs.yazi
      pkgs.glow
      pkgs.bitwarden-desktop
      pkgs.vesktop
      pkgs.pavucontrol
      pkgs.pipewire
      pkgs.slurp
      pkgs.grim
      pkgs.pulseaudio
      pkgs.pulseaudio-ctl
      pkgs.qalculate-gtk
      pkgs.lutris
      pkgs.steam-run
      pkgs.protonup-ng
      pkgs.winetricks
      pkgs.wine
      pkgs.wine-staging
      pkgs.wineWow64Packages.staging
      pkgs.gnutls
      pkgs.xinit
      pkgs.ttyd
      pkgs.git
      pkgs.gh
      pkgs.nix-output-monitor
      pkgs.nvd
      pkgs.nh
      pkgs.just
      pkgs.fh
      pkgs.rbw
      pkgs.secretspec
      pkgs.sops
      pkgs.age
      pkgs.rofi-rbw-wayland
      pkgs.ffmpeg_6-full
      pkgs.exiftool
      pkgs.mpv
      pkgs.mpd
      pkgs.imv
      pkgs.btop
      pkgs.tree
      pkgs.dysk
      pkgs.tealdeer
      pkgs.wl-clipboard
      pkgs.cliphist
      pkgs.wtype
      pkgs.curl
      pkgs.w3m
      pkgs.wget
      pkgs.wget2
      pkgs.fzf
      pkgs.ripgrep
      pkgs._7zz
      pkgs.poppler-utils
      pkgs.imagemagick
      pkgs.resvg
      pkgs.aider-chat
      pkgs.fd
      pkgs.bun
      pkgs.devenv
      pkgs.starship
      pkgs.fastfetch
      pkgs.atuin
      pkgs.libnotify
      pkgs.aria2
      pkgs.monero-cli
      pkgs.easyeffects
      pkgs.quickshell
      Kde.qtdeclarative
      Kde.qtsvg
      Kde.qt5compat
      Kde.kwin
      pkgs.devenv
      pkgs.nixfmt
      pkgs.jq
      pkgs.bat
      pkgs.ventoy
      pkgs.wl-screenrec
      pkgs.lolcat
      Gst.gstreamer
      Gst.gst-plugins-base
      Gst.gst-plugins-good
      Gst.gst-plugins-bad
      Gst.gst-plugins-ugly
      Gsr
      # For Dendritic Test-VM
      pkgs.xhost
      # Audio Wiring
      #pkgs.qpwgraph
      pkgs.helvum
      # Wifi Monitor Tools
      pkgs.iw
      pkgs.wavemon
      # Nix Config to XML
      pkgs.repomix
      # Disabled PKGS
      #pkgs.sway
      #pkgs.delicious-sddm-theme
      # Hyprland Ecosystem
      #pkgs.hyprpolkitagent
      #pkgs.waybar
      #pkgs.mako
      #pkgs.wofi
      #pkgs.hyprshot
      #pkgs.hyprpicker
      #pkgs.hyprpaper
    ]
    ++ [
      inputs.zen-browser.packages.${pkgs.system}.default
      inputs.nvf.packages.${pkgs.system}.default
      #inputs.llm-agents.packages.${pkgs.system}.default
      Cuda.cuda_nvcc
      Cuda.cudatoolkit
    ];
  };
}
