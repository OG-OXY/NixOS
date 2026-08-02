{
  pkgs,
  ...
}:
{
  home.file = {
    "./NixOS/Master/config/hypr/.luarc.json".text = builtins.toJSON {
      workspace = {
        library = [
          "${pkgs.hyprland}/share/hypr/stubs"
        ];
      };
      diagnostics = {
        globals = [ "hl" ];
      };
    };
    "./NixOS/Dendritic/config/hypr/.luarc.json".text = builtins.toJSON {
      workspace = {
        library = [
          "${pkgs.hyprland}/share/hypr/stubs"
        ];
      };
      diagnostics = {
        globals = [ "hl" ];
      };
    };
  };
}
