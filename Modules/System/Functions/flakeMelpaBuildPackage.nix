{
   ...
}:
{
  flake.nixosModules.flakeMelpaBuildPackage = { ... }:
  {
    nixpkgs.overlays = [
      (_final: _prev: {
        mkFpkg = epkgs: pname: src: packageRequires:
          epkgs.melpaBuild {
            inherit pname src packageRequires;
            version = "1.0.0";
          };
      })
    ];
  };
}
