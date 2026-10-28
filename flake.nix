#flake.nix
{
  description = "System Flake";
  
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-26.05";
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:denful/import-tree";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    rusty-clip.url = "github:OG-OXY/rusty-clip";
    llm-agents.url = "path:./Flakes/LLM-Agents";
    chaotic = {
      url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    doom = {
      url = "github:marienz/nix-doom-emacs-unstraightened";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ## Doom Pkgs
    majutsu = {
      url = "github:0WD0/majutsu";
      flake = false;
    };
    image-roll = {
      url = "github:dalanicolai/image-roll.el";
      flake = false;
    };
    hel = {
      url = "github:helheim-emacs/hel";
      flake = false;
    };
    ##
    ## Emacs Pkgs
    doom-dashboard = {
      url = "github:emacs-dashboard/doom-dashboard";
      flake = false;
    };
    ##
    ## Yazi Plugins
    ya-packs = {
      url = "github:yazi-rs/plugins";
      flake = false;
    };
    ya-ship = {
      url = "github:Rolv-Apneseth/starship.yazi";
      flake = false;
    };
    ##
    base16-schemes = {
      url = "github:tinted-theming/schemes";
      flake = false;
    };
  };
  
  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./Modules);
}
# Disabled
# nvf.url = "path:./Flakes/NVF";
#stylix = {
#  url = "github:nix-community/stylix";
#  inputs.nixpkgs.follows = "nixpkgs";
#};
# helix = {
#   url = "github:mattwparas/helix";
#   inputs.nixpkgs.follows = "nixpkgs";
# };
# steel = {
#   url = "github:mattwparas/steel";
#   inputs.nixpkgs.follows = "nixpkgs";
# };
