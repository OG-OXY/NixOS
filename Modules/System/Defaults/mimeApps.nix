{
  ...
}:
{
  flake.nixosModules.mimeApps = { ... }:
  {
    xdg.mime = {
      enable = true;
      defaultApplications = {
        "text/markdown" = [ "glow -p" ];
        "text/org" = [ "glow -p" ];
      };
    };
  };
}
