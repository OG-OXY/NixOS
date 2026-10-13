{
  ...
}:
{ 
  flake.nixosModules.helix = { pkgs, ... }:
  let
    helixConfig = pkgs.writeText "config.toml" ''
      theme = "base16_terminal"
      [editor]
      auto-format = true
      cursorline = true
      bufferline = "multiple"
      line-number = "relative"
      indent-guides = { render = true, character = "│" }
  
      [editor.cursor-shape]
      normal = "block"
      insert = "bar"
      select = "underline"
    '';
  
    helixLanguages = pkgs.writeText "languages.toml" ''
      [language-server.efm]
      command = "efm-langserver"

      [[language]]
      name = "nix"
      auto-format = false
      language-servers = [ "nixd", "efm" ]

      [[language]]
      name = "yaml"
      language-servers = [ "yaml-language-server", "efm" ]
      formatter = { command = "prettier", args = [ "--parser", "yaml" ] }
    '';

    efmConfig = pkgs.writeText "efm-langserver-config.yaml" ''
      version: 2
      locales: []
      root-markers:
        - flake.nix
        - devenv.nix
        - .git
        - .jj
      languages:
        nix:
          - lint-command: 'statix check --err --format=errtags %filepath'
            lint-workspace: false
            lint-source: 'statix'
            lint-formats:
              - '%f:%l:%c:%t:%m'

          - lint-command: 'deadnix --no-lambda %filepath'
            lint-source: 'deadnix'
            lint-formats:
              - '%f:%l:%c: %m'
        yaml:
          - lint-command: 'yamllint -f parsable -'
            lint-stdin: true
            lint-formats:
              - '%f:%l:%c: [%t%*[^]] %m'
    '';
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
      # Shell
      pkgs.fish-lsp
      pkgs.bash-language-server        
    ];
    
    systemd.tmpfiles.rules = [
      "d /home/ty/.config/helix 0755 ty users -"
      "d /home/ty/.config/helix/themes 0755 ty users -"
      "d /home/ty/.config/efm-langserver 0755 ty users -"
      "L+ /home/ty/.config/helix/config.toml - - - - ${helixConfig}"
      "L+ /home/ty/.config/helix/languages.toml - - - - ${helixLanguages}"
      "L+ /home/ty/.config/efm-langserver/config.yaml - - - - ${efmConfig}"
    ];
  };
}

