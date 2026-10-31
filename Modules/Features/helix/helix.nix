{
  ...
}:
{ 
  flake.nixosModules.helix = { pkgs, ... }:
  let
    # Helix
    helixConfig = ./config.toml;
    helixLanguages = ./languages.toml;
    helixTheme = ./theme.toml;
    helixSteel = pkgs.symlinkJoin {
      name = "steel-wrapped";
      paths = [ pkgs.steelix ];
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        mv $out/bin/hx $out/bin/sx 
      '';    
    };
    # Steel
    steelSCM = ./steel.scm;
    steelInit = ./init.scm;
    steelSplash = ./splash.scm;
    # EFM Diagnostics Proxy
    efmConfig = ./efm-langserver.yaml;
  in
  {
    environment.systemPackages = [
      # Helix
      pkgs.helix
      # Steel With LSP & REPL
      helixSteel
      pkgs.steel
      pkgs.steel-language-server
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
      # Markdown
      pkgs.marksman
      pkgs.markdown-oxide
      pkgs.markdownlint-cli2
      pkgs.zk
      # HTML
      pkgs.vscode-html-languageserver
      # CSS
      pkgs.vscode-css-languageserver
      # Lisp
      pkgs.sbcl
      pkgs.roswell
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
      "L+ /home/ty/.config/helix/helix.scm - - - - ${steelSCM}"
      "L+ /home/ty/.config/helix/init.scm - - - - ${steelInit}"
      "L+ /home/ty/.config/helix/splash.scm - - - - ${steelSplash}"
      "L+ /home/ty/.config/efm-langserver/config.yaml - - - - ${efmConfig}"
    ];
  };
}
