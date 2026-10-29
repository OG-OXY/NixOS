{
  ... 
}:
{
  flake.nixosModules.kakoune = { pkgs, ... }:
  {
    environment.systemPackages = [
      pkgs.kakoune
      pkgs.kakoune-lsp
      pkgs.kak-tree-sitter
    ];
  };
}
