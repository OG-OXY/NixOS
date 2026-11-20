{
   ...
}:
{
  flake.nixosModules.flakeMelpaBuildPackage = { ... }:
  {
    nixpkgs.overlays = [
      (_final: _prev: {
        mkFpkgs = epkgs: pname: src: packageRequires:
          epkgs.melpaBuild {
            inherit pname src packageRequires;
            version = "1.0.0";
          };
      })
    ];
  };
}

# extraPackages = epkgs:
# let
#   fpkgs = pname: src: packageRequires: epkgs.melpaBuild {
#     inherit pname src packageRequires;
#     version = "1.0.0";
#   };
# in
