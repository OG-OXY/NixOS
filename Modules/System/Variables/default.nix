{
  ...
}:
{
  flake.nixosModules.environment = { pkgs, ... }:
  {
    environment = {
      shells = [ pkgs.fish ];
      variables = {
        CPATH = "/run/current-system/sw/include";
        LIBRARY_PATH = "/run/current-system/sw/lib";
      };
      sessionVariables = {
        XDG_CURRENT_DESKTOP = "niri:GNOME";
        NIXOS_OZONE_WL = "1";
        ELECTRON_OZONE_PLATFORM_HINT = "auto";
        XDG_SESSION_TYPE = "wayland";
        GDK_BACKEND = "wayland,x11";
        GBM_BACKEND = "nvidia-drm";
        ## Added back after VK swapchain incident didnt seem to do anything(i think), could cause adverse effects to obs though
        #NVD_BACKEND = "direct";
        ##
        QT_QPA_PLATFORM = "wayland;xcb";
        SDL_VIDEO_DRIVER = "wayland,x11";
        ## Does this belong in niri config or here?
        ## Commented out after steam-desktop error fix
        #LIBVA_DRIVER_NAME = "nvidia";
        ##
        #PIPEWIRE_NODE = "2";
        # Nvidia card does use EGL to for vulkan layer
        #OBS_USE_EGL = "0";
        # Maybe i should add this back?..
        #WLR_RENDERER = "vulkan"; 
        PROTON_ENABLE_WAYLAND = "1";
        PROTON_ENABLE_NVAPI = "1";
        #ENABLE_GAMESCOPE_WSI = "1";
        STEAM_EXTRA_COMPAT_TOOLS_PATHS = "$HOME/.steam/root/compatibilitytools.d";
        WLR_NO_HARDWARE_CURSORS = "0";
        EDITOR = "nvf";
        VISUAL = "nvf";
        SSH_AUTH_SOCK = "/home/ty/.bitwarden-ssh-agent.sock";
        SECRETSPEC_PROVIDER = "keyring";
        ANTHROPIC_API_KEY = "local";
        ANTHROPIC_AUTH_TOKEN = "ollama";
        ANTHROPIC_BASE_URL = "http://127.0.0.1:11434";
        ANTHROPIC_DEFAULT_SONNET_MODEL = "qwen-32b";
        ANTHROPIC_DEFAULT_OPUS_MODEL = "qwen2.5-coder";
        ANTHROPIC_DEFAULT_HAIKU_MODEL = "qwen2.5-coder";
        OLLAMA_CONTEXT_LENGTH = "32768";
        CLAUDE_CODE_ATTRIBUTION_HEADER = "0";
        CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC = "1";
        # Redundant?..
        NODE_OPTIONS = "--dns-result-order=ipv4first";
      };
    };
  };
}
