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
      # Proxy-Server
      pkgs.efm-langserver
      # Nix
      pkgs.nixd
      pkgs.deadnix
      pkgs.statix
      pkgs.nixfmt-rs
      # Rust
      pkgs.rust-analyzer
      pkgs.clippy
      pkgs.bacon
      # Shell
      pkgs.fish-lsp
      pkgs.bash-language-server        
      # Lua
      pkgs.lua-language-server
      pkgs.hyprls
      pkgs.stylua
      # JSON
      pkgs.jq
      # Yaml
      pkgs.yaml-language-server
      pkgs.yamllint
      pkgs.prettier
      # Toml
      pkgs.taplo
      # jq
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

