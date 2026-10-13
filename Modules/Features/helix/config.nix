{
  ...
}:
{
  flake.nixosModules.helix = { pkgs, ... }:
  let
    helixConfig = pkgs.writeText "config.toml" ''
      theme = "base16_terminal"
      [editor]
      line-number = "relative"
      cursorline = true
      bufferline = "multiple"
      indent-guides = { render = true, character = "│" }
      auto-format = true
  
      [editor.cursor-shape]
      normal = "block"
      insert = "bar"
      select = "underline"
    '';
  
    helixLanguages = pkgs.writeText "languages.toml" ''
      [[language]]
      name = "nix"
      auto-format = false
    '';

    # helixTheme = pkgs.writeText "base16_custom.toml" ''
      # inherits = "base16_terminal"
      # "ui.cursorline.primary" = { bg = "#282a36" }
      # "ui.cursorline.secondary" = { bg = "#21222c" }
      # "ui.background" = {}    
    # '';
  in
  {
    environment.systemPackages = [ pkgs.helix ];
    systemd.tmpfiles.rules = [
      "d /home/ty/.config/helix 0755 ty users -"
      "d /home/ty/.config/helix/themes 0755 ty users -"
      "L+ /home/ty/.config/helix/config.toml - - - - ${helixConfig}"
      "L+ /home/ty/.config/helix/languages.toml - - - - ${helixLanguages}"
      # "L+ /home/ty/.config/helix/themes/base16_custom.toml - - - - ${helixTheme}"
    ];
  };
}
