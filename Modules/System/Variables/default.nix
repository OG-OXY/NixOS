{
  ...
}:
{
  flake.nixosModules.environment = { pkgs, ... }:
  {
    environment = {
      shells = [ pkgs.fish ];
      variables = {
        #CPATH = "/run/current-system/sw/include";
        #LIBRARY_PATH = "/run/current-system/sw/lib";
      };
      sessionVariables = {
        XDG_CURRENT_DESKTOP = "niri:GNOME";
        XDG_SESSION_TYPE = "wayland";

        # Toolkit Backends
        GDK_BACKEND = "wayland,x11";
        QT_QPA_PLATFORM = "wayland;xcb";
        SDL_VIDEO_DRIVER = "wayland,x11";
        CLUTTER_BACKEND = "wayland";

        # Electron / Chrome Wayland Native
        ELECTRON_OZONE_PLATFORM_HINT = "auto";
        NIXOS_OZONE_WL = "1";

        # NVIDIA & Driver Hardware Acceleration
        GBM_BACKEND = "nvidia-drm";
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        LIBVA_DRIVER_NAME = "nvidia";
        NVD_BACKEND = "direct";

        # Gaming & Proton Optimization (Low Latency / NVAPI)
        PROTON_ENABLE_WAYLAND = "1";
        PROTON_ENABLE_NVAPI = "1";
        STEAM_EXTRA_COMPAT_TOOLS_PATHS = "$HOME/.steam/root/compatibilitytools.d";

        # Core Tools & SSH
        EDITOR = "nvf";
        VISUAL = "nvf";
        SSH_AUTH_SOCK = "/home/ty/.bitwarden-ssh-agent.sock";
        SECRETSPEC_PROVIDER = "keyring";

        # Local Ollama AI Proxy Routing
        ANTHROPIC_API_KEY = "local";
        ANTHROPIC_AUTH_TOKEN = "ollama";
        ANTHROPIC_BASE_URL = "http://127.0.0.1:11434";
        ANTHROPIC_DEFAULT_SONNET_MODEL = "qwen-32b";
        ANTHROPIC_DEFAULT_OPUS_MODEL = "qwen2.5-coder";
        ANTHROPIC_DEFAULT_HAIKU_MODEL = "qwen2.5-coder";
        OLLAMA_CONTEXT_LENGTH = "32768";
        CLAUDE_CODE_ATTRIBUTION_HEADER = "0";
        CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC = "1";

        # Node / Network Tweaks
        NODE_OPTIONS = "--dns-result-order=ipv4first";
      };
    };
  };
}
