{
  inputs,
  ...
}:
{
  flake.nixosModules.systemPackages = { pkgs, ... }:
  {
    environment.systemPackages = let
      Cuda = pkgs.cudaPackages_12_6;
      Kde = pkgs.kdePackages;
      py3 = pkgs.python313Packages;
      Gst = pkgs.gst_all_1;
      Gsr = pkgs.gpu-screen-recorder.override {
        ffmpeg = pkgs.ffmpeg_6;
      };
      llama = pkgs.llama-cpp-cuda.overrideAttrs (oldAttrs: {
        cmakeFlags = (oldAttrs.cmakeFlags or []) ++ [
          "-DGGML_CUDA=ON"
          "-DCMAKE_CUDA_ARCHITECTURES=61"
          "-DGGML_CUDA_FORCE_MMQ=ON"
          "-DGGML_CUDA_FA_ALL_QUANTS=ON"
        ];
      });
    in
    [
      # ============================================================================
      # 1. CORE SYSTEM, DISPLAY & DESKTOP SUITE
      # ============================================================================
      pkgs.xwayland-satellite
      pkgs.noctalia
      pkgs.polkit_gnome
      pkgs.pinentry-qt
      pkgs.libnotify
      pkgs.quickshell
      pkgs.gnutls
      pkgs.xinit
      pkgs.xhost    
      pkgs.sqlite
      Kde.kwin
      Kde.qtdeclarative
      Kde.qtsvg
      Kde.qt5compat
    
      # ============================================================================
      # 2. SYSTEM MANAGEMENT & NIX FLAKE TOOLING
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
      # ============================================================================
      pkgs.ghostty
      pkgs.alacritty
      pkgs.yazi
      pkgs.starship
      pkgs.atuin
      pkgs.fastfetch
      pkgs.ttyd
      pkgs.waypipe
      pkgs.wayvnc
      pkgs.chafa
      pkgs.glow
      pkgs.tealdeer
      pkgs.tree
      pkgs.lolcat
      
      # ============================================================================
      # 4. GUI APPLICATIONS
      # ============================================================================
      pkgs.bitwarden-desktop
      pkgs.vesktop
      pkgs.pavucontrol
      pkgs.qalculate-gtk
    
      # ============================================================================
      # 5. GAMING, PROTON & WINE ENVIRONMENT
      # ============================================================================
      pkgs.lutris
      pkgs.protonup-ng
      pkgs.winetricks
      pkgs.wineWow64Packages.staging
      pkgs.mangohud
    
      # ============================================================================
      # 6. MEDIA PLAYBACK, CAPTURE, RECORDING & EDITING
      # ============================================================================
      # Higher-Level GUI & CLI Players
      pkgs.mpv
      pkgs.imv
      pkgs.mpd
      pkgs.playerctl
    
      # Screen & Capture Utilities
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
      pkgs.pandoc
    
      # GStreamer Engine & Plugin Suite
      Gst.gstreamer
      Gst.gst-plugins-base
      Gst.gst-plugins-good
      Gst.gst-plugins-bad
      Gst.gst-plugins-ugly
    
      # ============================================================================
      # 7. AUDIO, NETWORK & HARDWARE MONITORING
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
      # C / C++ TOOLCHAIN & COMPILERS
      # ============================================================================
      pkgs.gcc                        # Standard GNU C/C++ compiler suite
      pkgs.clang                      # LLVM C/C++ compiler suite
      pkgs.gdb                        # GNU Debugger
      pkgs.lldb                       # LLVM Debugger
      pkgs.cmake                      # Modern C/C++ build system
      pkgs.ninja                      # Fast parallel build tool
      pkgs.gnumake                    # Traditional Makefile tool
      pkgs.pkg-config                 # Shared library discovery utility
      pkgs.bear                       # Generates compile_commands.json for LSP indexing

      # ============================================================================
      # C / C++ LSP, FORMATTERS, & DIAGNOSTICS
      # ============================================================================
      pkgs.llvmPackages.clang-tools   # Provides clangd (LSP), clang-format, & clang-tidy
      pkgs.cppcheck                   # Static analysis & linting for C/C++
      pkgs.valgrind                   # Memory leak detection & profiling

      # ============================================================================
      # 8. DEVELOPMENT TOOLCHAIN & ENVIRONMENT BOOTSTRAPPING
      # ============================================================================
      pkgs.devenv
      pkgs.jujutsu
      pkgs.git
      pkgs.gh
      pkgs.bacon
      pkgs.cargo-edit
      pkgs.cargo-expand
      pkgs.qmk
      pkgs.nodejs_22
      pkgs.just
      pkgs.bun
      pkgs.repomix # Nix Config to XML
      llama
      pkgs.geminicommit
      py3.huggingface-hub
      pkgs.watchman
    
      # ============================================================================
      # 9. CLI NAVIGATION, MANIPULATION & HELPER UTILITIES
      # ============================================================================
      pkgs.binutils
      pkgs.pciutils
      pkgs.usbutils
      pkgs.lshw
      pkgs.fzf
      pkgs.ripgrep
      pkgs.gawk
      pkgs.bat
      pkgs.fd
      pkgs.ethtool
      pkgs.lm_sensors
      pkgs.udisks2
      pkgs.w3m
      pkgs.curl
      pkgs.wget
      pkgs.wget2
      pkgs.aria2
      pkgs._7zz-rar
      pkgs.localsend
      pkgs.wl-clipboard
      pkgs.cliphist
      pkgs.wtype
      pkgs.rofi-rbw-wayland
      pkgs.rbw
      pkgs.ventoy
      pkgs.monero-cli
    
      # ============================================================================
      # DISABLED PACKAGES (ORGANIZED BY SUBCATEGORY)
      # ============================================================================
      # pkgs.sway
      # pkgs.delicious-sddm-theme
      # pkgs.wine
      # pkgs.wine-staging
      # pkgs.nvimpager
    
      # --- Disabled: Hyprland Ecosystem ---
      # pkgs.hyprpolkitagent
      # pkgs.waybar
      # pkgs.mako
      # pkgs.wofi
      # pkgs.hyprshot
      # pkgs.hyprpicker
      # pkgs.hyprpaper
    ]
    ++ [
      # ============================================================================
      # ACTIVE FLAKE INPUTS & HARDWARE ACCELERATION TOOLCHAINS
      # ============================================================================
      inputs.zen-browser.packages.${pkgs.system}.default
      inputs.llm-agents.packages.${pkgs.system}.default
      Cuda.cuda_nvcc
      Cuda.cudatoolkit
      # --- Disabled Flake Inputs ---
      # inputs.nvf.packages.${pkgs.system}.default
    ];
  };
}
