{
  ...
}:
{ 
  flake.nixosModules.helix = { pkgs, ... }:
  let
    helixConfig = ./config.toml;
    helixLanguages = ./languages.toml;
    helixTheme = ./theme.toml;
    # helixSteel = pkgs.symlinkJoin {
    #   name = "steel-wrapped";
    #   paths = [ pkgs.steelix ];
    #   buildInputs = [ pkgs.makeWrapper ];
    #   postBuild = ''
    #     mv $out/bin/hx $out/bin/sx 
    #   '';    
    # };
    Rust = pkgs.rust-bin.stable.latest.default.override {
      extensions = [ "rust-src" "rust-analyzer" "clippy" "rustfmt" ];
    };
    initSCM = ./init.scm;
    steelSCM = ./steel.scm;
    efmConfig = ./efm-langserver.yaml;
  in
  {
    environment = {
      systemPackages = [
        # Helix
        # pkgs.helix
        # Steel With LSP & REPL
        # helixSteel
        pkgs.steelix
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
        Rust
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
    };
    systemd.userLinks = [
      { path = ".config/helix/config.toml"; source = helixConfig; }
      { path = ".config/helix/languages.toml"; source = helixLanguages; }
      { path = ".config/helix/themes/base16_custom.toml"; source = helixTheme; }
      { path = ".config/helix/init.scm"; source = initSCM; }
      { path = ".config/helix/helix.scm"; source = steelSCM; }
      { path = ".config/efm-langserver/config.yaml"; source = efmConfig; }
    ];
  };
}
