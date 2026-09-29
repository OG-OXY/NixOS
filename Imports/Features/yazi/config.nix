{
  ...
}:
{
  flake.nixosModules.yazi = { ... }:
  {
    programs.yazi = {
      enable = true;
      enableFishIntegration = true;
      settings = {
        yazi = {
          manager = {
            show_hidden = true;
            sort_by = "mtime";
            sort_sensitive = false;
            sort_reverse = true;
          };
        };
      };
    };
  };
}
