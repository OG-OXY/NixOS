{
  ...
}:
{ 
  flake.nixosModules.helix = { pkgs, ... }:
  let
    helixConfig = ./config.toml;
    helixLanguages = ./languages.toml;
    helixTheme = ./theme.toml;
    Rust = pkgs.rust-bin.stable.latest.default.override {
      extensions = [ "rust-src" "rust-analyzer" "clippy" "rustfmt" ];
    };
    initSCM = ./init.scm;
    helixSCM = ./helix.scm;
    efmConfig = ./efm-langserver.yaml;
  in
  {
    environment = {
      systemPackages = [
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
      { path = ".config/helix/helix.scm"; source = helixSCM; }
      { path = ".config/efm-langserver/config.yaml"; source = efmConfig; }
    ];
  };
}
