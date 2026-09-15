{
  pkgs,
  ...
}:
{
  home.file = {
    "./NixOS/Master/Config/Hypr/.luarc.json".text = builtins.toJSON {
      workspace = {
        library = [
          "${pkgs.hyprland}/share/hypr/stubs"
        ];
      };
      diagnostics = {
        globals = { hl = true; };
      };
    };
  };
}
