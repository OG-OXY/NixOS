{ ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    package = null; # Prevents Home Manager from double-installing the binary package
    settings = {
      permission = [
        "/nix/store/[a-z0-9]{32}-grim-[0-9.]*/bin/grim, screencopy, allow"
        "/nix/store/[a-z0-9]{32}-xdg-desktop-portal-hyprland-[0-9.]*/libexec/.*xdg-desktop-portal-hyprland.*, screencopy, allow"
        "/nix/store/[a-z0-9]{32}-hyprland-[0-9.]*/bin/hyprpm, plugin, allow"
        "/nix/store/[a-z0-9]{32}-hyprshot-[0-9.]*/bin/hyprshot, screencopy, allow"
        "/nix/store/[a-z0-9]{32}-woomer-[0-9.]*/bin/woomer, screencopy, allow"
      ];
    };
  };
}
