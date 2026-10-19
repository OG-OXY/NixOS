{
  ...
}:
{
  flake.nixosModules.sessionVariables = { pkgs, ... }:
  {
    environment = {
      shells = [ 
        pkgs.fish
        pkgs.nushell
      ];
      sessionVariables = {
        XDG_CURRENT_DESKTOP = "niri:GNOME";
        XDG_SESSION_TYPE = "wayland";
        EDITOR = "hx";
        VISUAL = "hx";

        # Toolkit Backends
        GDK_BACKEND = "wayland,x11";
        QT_QPA_PLATFORM = "wayland;xcb";
        SDL_VIDEO_DRIVER = "wayland,x11";
        CLUTTER_BACKEND = "wayland";

        # Wayland / Electron
        NIXOS_OZONE_WL = "1";
        ELECTRON_OZONE_PLATFORM_HINT = "auto";

        # NVIDIA / Driver
        GBM_BACKEND = "nvidia-drm";
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        LIBVA_DRIVER_NAME = "nvidia";
        NVD_BACKEND = "direct";
        EGL_ALLOW_UNSUPPORTED_EXTENSIONS = "1";
        EGL_PLATFORM = "wayland";

        # Gaming / Proton
        PROTON_ENABLE_WAYLAND = "1";
        PROTON_ENABLE_NVAPI = "1";
        STEAM_EXTRA_COMPAT_TOOLS_PATHS = "$HOME/.steam/root/compatibilitytools.d";

        # SSH & AI
        SSH_AUTH_SOCK = "/home/ty/.bitwarden-ssh-agent.sock";
        OPENAI_HOST= "http://127.0.0.1:8012";
        OPENAI_BASE_PATH= "/v1/chat/completions";
        OPENAI_API_KEY= "not-needed";
        ANTHROPIC_API_KEY = "local";
        ANTHROPIC_BASE_URL = "http://127.0.0.1:11434";
        ANTHROPIC_DEFAULT_SONNET_MODEL = "qwen-32b";
        ANTHROPIC_DEFAULT_OPUS_MODEL = "qwen2.5-coder";
        ANTHROPIC_DEFAULT_HAIKU_MODEL = "qwen2.5-coder";
        OLLAMA_CONTEXT_LENGTH = "32768";
        CLAUDE_CODE_ATTRIBUTION_HEADER = "0";
        CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC = "1";

        # Node / Network
        NODE_OPTIONS = "--dns-result-order=ipv4first";
      };
    };
  };
}
# Old or Not Used
# ANTHROPIC_AUTH_TOKEN = "ollama";
# SECRETSPEC_PROVIDER = "keyring";
# GOOSE_PROVIDER = "openai";
# GOOSE_PROVIDER__HOST = "http://127.0.0.1:8012";
# GOOSE_PROVIDER__API_KEY = "not-needed";
# GOOSE_MODEL = "qwen2.5-coder";
