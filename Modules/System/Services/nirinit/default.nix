{
  ...
}:
{
  flake.nixosModules.nirinit = { ... }:
  {
    services.nirinit = {
      enable = false;
      settings = {
        skip.apps = [ 
          "steam"
          "lutris"
        ];
      };
    };
  };
}
