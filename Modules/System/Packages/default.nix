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
      # ============================================================================
      # 1. CORE SYSTEM, DISPLAY & DESKTOP SUITE
      # Primary Wayland/X11 infrastructure, session services, and Qt/KDE engines
      # ============================================================================
      pkgs.xwayland-satellite
      pkgs.noctalia-shell
      pkgs.polkit_gnome
      pkgs.pinentry-qt
      pkgs.libnotify
      pkgs.quickshell
      pkgs.gnutls
      pkgs.xinit
      pkgs.xhost # For Dendritic Test-VM
    
      # KDE Core Framework Packages
      Kde.kwin
      Kde.qtdeclarative
      Kde.qtsvg
      Kde.qt5compat
    
      # ============================================================================
      # 2. SYSTEM MANAGEMENT & NIX FLAKE TOOLING
      # High-priority helpers for system rebuilds, flake evaluation, and secrets
      # ============================================================================
      pkgs.nh
      pkgs.nix-output-monitor
      pkgs.nvd
      pkgs.fh
      pkgs.sops
      pkgs.age
      pkgs.secretspec
    
      # ============================================================================
      # 3. INTERACTIVE SHELL & TERMINAL EMULATORS
      # Primary terminal environments and shell prompt integration
      # ============================================================================
      pkgs.ghostty
      pkgs.alacritty
      pkgs.yazi
      pkgs.starship
      pkgs.atuin
      pkgs.fastfetch
      pkgs.ttyd
    
      # ============================================================================
      # 4. GUI APPLICATIONS
      # Graphical user interface applications
      # ============================================================================
      pkgs.bitwarden-desktop
      pkgs.vesktop
      pkgs.pavucontrol
      pkgs.qalculate-gtk
      pkgs.ventoy
    
      # ============================================================================
      # 5. GAMING, PROTON & WINE ENVIRONMENT
      # Windows compatibility runtimes and gaming performance tools
      # ============================================================================
      pkgs.lutris
      pkgs.protonup-ng
      pkgs.winetricks
      pkgs.wineWow64Packages.staging
      pkgs.mangohud
    
      # ============================================================================
      # 6. MEDIA PLAYBACK, CAPTURE, RECORDING & EDITING
      # Higher-level players/recorders first down to core media codecs and libraries
      # ============================================================================
      # Higher-Level GUI & CLI Players
      pkgs.mpv
      pkgs.imv
      pkgs.mpd
    
      # Screen Recording & Capture Utilities
      pkgs.grim
      pkgs.slurp
      pkgs.wl-screenrec
      Gsr
    
      # Format Processing, Metadata & Encoding Core
      pkgs.ffmpeg_6-full
      pkgs.imagemagick
      pkgs.poppler-utils
      pkgs.exiftool
      pkgs.resvg
    
      # GStreamer Engine & Plugin Suite
      Gst.gstreamer
      Gst.gst-plugins-base
      Gst.gst-plugins-good
      Gst.gst-plugins-bad
      Gst.gst-plugins-ugly
    
      # ============================================================================
      # 7. AUDIO, NETWORK & HARDWARE MONITORING
      # Audio routing, network diagnostics, and hardware monitoring
      # ============================================================================
      pkgs.easyeffects
      pkgs.helvum
      pkgs.pulseaudio-ctl
      pkgs.btop
      pkgs.dysk
      pkgs.udiskie
      pkgs.iw
      pkgs.wavemon
    
      # ============================================================================
      # 8. DEVELOPMENT TOOLCHAIN & ENVIRONMENT BOOTSTRAPPING
      # Interactive dev tools, shell engines, formatters, and AI helpers
      # ============================================================================
      pkgs.git
      pkgs.gh
      pkgs.devenv
      pkgs.just
      pkgs.bun
      pkgs.nixfmt
      pkgs.jq
      pkgs.repomix # Nix Config to XML
      pkgs.aider-chat
      pkgs.watchman
    
      # ============================================================================
      # 9. CLI NAVIGATION, MANIPULATION & HELPER UTILITIES
      # Searchers, clipboard tools, file helpers, and text utilities
      # ============================================================================
      pkgs.binutils
      pkgs.pciutils
      pkgs.usbutils
      pkgs.lshw
      pkgs.fzf
      pkgs.ripgrep
      pkgs.fd
      pkgs.bat
      pkgs.ethtool
      pkgs.lm_sensors
      pkgs.glow
      pkgs.nvimpager
      pkgs.wl-clipboard
      pkgs.cliphist
      pkgs.wtype
      pkgs.rofi-rbw-wayland
      pkgs.rbw
      pkgs.curl
      pkgs.wget
      pkgs.wget2
      pkgs.aria2
      pkgs.localsend
      pkgs.w3m
      pkgs.tealdeer
      pkgs.tree
      pkgs._7zz
      pkgs.udisks2
      pkgs.monero-cli
      pkgs.chafa
      pkgs.lolcat
    
      # ============================================================================
      # DISABLED PACKAGES (ORGANIZED BY SUBCATEGORY)
      # Preserved for reference, development testing, or future re-activation
      # ============================================================================
    
      # --- Disabled: Window Managers, Desktop Shells & Themes ---
      # pkgs.sway
      # pkgs.delicious-sddm-theme
      # pkgs.gnome-settings-daemon
      # pkgs.gsettings-desktop-schemas
    
      # --- Disabled: Hyprland Ecosystem ---
      # pkgs.hyprpolkitagent
      # pkgs.waybar
      # pkgs.mako
      # pkgs.wofi
      # pkgs.hyprshot
      # pkgs.hyprpicker
      # pkgs.hyprpaper
    
      # --- Disabled: Development, Compilers & Debuggers ---
      # pkgs.stdenv.cc
      # pkgs.gnumake
      # pkgs.cmake
      # pkgs.pkg-config
      # pkgs.gdb
      # pkgs.valgrind
    
      # --- Disabled: Alternative Wine Builds ---
      # pkgs.wine
      # pkgs.wine-staging
    
      # --- Disabled: Audio Daemons & Wiring ---
      # pkgs.pipewire
      # pkgs.pulseaudio
      # pkgs.qpwgraph
    ]
    ++ [
      # ============================================================================
      # ACTIVE FLAKE INPUTS & HARDWARE ACCELERATION TOOLCHAINS
      # ============================================================================
      inputs.zen-browser.packages.${pkgs.system}.default
      inputs.nvf.packages.${pkgs.system}.default
      Cuda.cuda_nvcc
      Cuda.cudatoolkit
      # --- Disabled Flake Inputs ---
      # inputs.llm-agents.packages.${pkgs.system}.default
    ];
  };
}
