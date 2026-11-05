{
  ...
}:
{
  flake.homeModules.mpv = { pkgs, ... }:
  {
    programs.mpv = {
      enable = true;
      config = {
        profile = "high-quality";
        gpu-api = "vulkan";
        vo = "gpu-next";
        scale = "ewa_lanczossharp";
        cscale = "lanczos";
        dscale = "mitchell";
        correct-downscaling = "yes";
        linear-downscaling = "yes";
        sigmoid-upscaling = "yes";
        deband = "yes";
        hwdec = "auto-safe";
        keep-open = "yes";
        screenshot-format = "jxl";
        screenshot-high-bit-depth = "yes";
      };

      profiles = {
        "extension.jpg" = { profile = "image-mode"; };
        "extension.jpeg" = { profile = "image-mode"; };
        "extension.png" = { profile = "image-mode"; };
        "extension.webp" = { profile = "image-mode"; };
        "extension.jxl" = { profile = "image-mode"; };
        "extension.bmp" = { profile = "image-mode"; };
        "image-mode" = {
          image-display-duration = "inf";
          loop-file = "inf";
          osc = "no";
          osd-level = 0;
          video-rotate = "auto";
          reset-on-next-file = "video-aspect-override,loop-file,speed,sub-delay,video-pan-x,video-pan-y,video-zoom";
        };
      };

      bindings = {
        "RIGHT" = "seek 5";
        "LEFT"  = "seek -5";
        "l"     = "playlist-next";
        "h"     = "playlist-prev";
        "SPACE" = "playlist-next";
        "BS"    = "playlist-prev";
        "WHEEL_UP"   = "playlist-prev";
        "WHEEL_DOWN" = "playlist-next";
        "j"    = "add video-zoom -0.1";
        "k"    = "add video-zoom 0.1";
        "DOWN" = "add video-zoom -0.1";
        "UP"   = "add video-zoom 0.1";
        "="    = "add video-zoom 0.1";
        "-"    = "add video-zoom -0.1";
        "Shift+h" = "add video-pan-x 0.05";
        "Shift+l" = "add video-pan-x -0.05";
        "Shift+k" = "add video-pan-y 0.05";
        "Shift+j" = "add video-pan-y -0.05";
        "Alt+left"  = "add video-pan-x 0.05";
        "Alt+right" = "add video-pan-x -0.05";
        "Alt+up"    = "add video-pan-y 0.05";
        "Alt+down"  = "add video-pan-y -0.05";
        "r"      = "set video-zoom 0; set video-pan-x 0; set video-pan-y 0";
        "Ctrl+0" = "set video-zoom 0; set video-pan-x 0; set video-pan-y 0";
      };

      scripts = let
        mpv = pkgs.mpvScripts;
      in
      [
        mpv.mpris 
        mpv.autoload
      ];
    };
  };
}
