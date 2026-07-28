{
  ...
}:
let
  wallpaperDir = ../../config/theme/wpapers;

  wallpapers = map (file: "${wallpaperDir}/${file}") (
    builtins.attrNames (builtins.readDir wallpaperDir)
  );

  defaultWallpaper = "${wallpaperDir}/gruvbox-rainbow-nix.png";
in
{
  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      splash = false;
      preload = wallpapers;
      wallpaper = [
        {
          monitor = "";
          path = "${defaultWallpaper}";
        }
      ];
    };
  };
}
