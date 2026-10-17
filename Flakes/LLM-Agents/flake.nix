{
  description = "AI Agent-Hub Package with Devshell";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    llm-agents = {
      url = "github:numtide/llm-agents.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, llm-agents, ... }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      config = [
        nixpkgs.config.allowUnfree
        nixpkgs.config.cudaSupport
        nixpkgs.config.cudaCapabilities
      ];
    in
    {
      packages = forAllSystems (
        system:
        let
          llm = llm-agents.packages.${pkgs.system};
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          inherit config;
          default = pkgs.symlinkJoin {
            name = "numtide_llm-agents";
            paths = [
              llm.herdr
              llm.opencode
              llm.crush
              llm.goose-cli
              llm.copilot-cli
              llm.claude-code
              # llm.codex
            ];
          };
        }
      );
    };
}
