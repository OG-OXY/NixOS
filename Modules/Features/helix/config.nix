{
  ...
}:
{ 
  flake.nixosModules.helix = { pkgs, ... }:
  let
    helixConfig = ./helix-config.toml;
    helixLanguages = ./helix-languages.toml;
    helixTheme = ./helix-theme.toml;
    efmConfig = ./efm-langserver-config.yaml;
  in
  {
    environment.systemPackages = [
      pkgs.helix
      # Proxy-LS
      pkgs.efm-langserver
      # NIX
      pkgs.nixd
      pkgs.deadnix
      pkgs.statix
      pkgs.nixfmt-rs
      # RUST
      pkgs.rust-analyzer
      pkgs.clippy
      pkgs.bacon
      # SHELL
      pkgs.fish-lsp
      pkgs.bash-language-server        
      # LUA
      pkgs.lua-language-server
      pkgs.hyprls
      pkgs.stylua
      # JSON
      pkgs.vscode-json-languageserver
      pkgs.jq
      # YAML
      pkgs.yaml-language-server
      pkgs.yamllint
      pkgs.prettier
      # TOML
      pkgs.taplo
      # HTML
      pkgs.vscode-html-languageserver
      # CSS
      pkgs.vscode-css-languageserver
      # JQ
      pkgs.jq-lsp
      pkgs.jqfmt
    ];   
    systemd.tmpfiles.rules = [
      "d /home/ty/.config/helix 0755 ty users -"
      "d /home/ty/.config/helix/themes 0755 ty users -"
      "d /home/ty/.config/efm-langserver 0755 ty users -"
      "L+ /home/ty/.config/helix/config.toml - - - - ${helixConfig}"
      "L+ /home/ty/.config/helix/languages.toml - - - - ${helixLanguages}"
      "L+ /home/ty/.config/helix/themes/base16_custom.toml - - - - ${helixTheme}"
      "L+ /home/ty/.config/efm-langserver/config.yaml - - - - ${efmConfig}"
    ];
  };
}
