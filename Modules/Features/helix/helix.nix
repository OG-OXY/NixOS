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
        #PYTHON
        pkgs.basedpyright
        pkgs.ruff
        #RUBY
        pkgs.ruby-lsp
        pkgs.rufo
        pkgs.rubyfmt
        # Lisp
        pkgs.sbcl
        pkgs.roswell
        # SHELL
        pkgs.nu-lint
        pkgs.nufmt
        pkgs.fish-lsp
        pkgs.bash-language-server
        # JSON
        pkgs.vscode-json-languageserver
        pkgs.jq
        # YAML
        pkgs.yaml-language-server
        pkgs.yamllint
        pkgs.prettier
        # TOML
        pkgs.taplo
        # LUA
        pkgs.lua-language-server
        pkgs.hyprls
        pkgs.stylua
        # HTML
        pkgs.vscode-html-languageserver
        # Markdown
        pkgs.marksman
        pkgs.markdown-oxide
        pkgs.markdownlint-cli2
        pkgs.zk
        # CSS
        pkgs.vscode-css-languageserver
        # SQL
        pkgs.sqls
        pkgs.sqlint
        pkgs.sql-formatter
        pkgs.sqlfluff
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
