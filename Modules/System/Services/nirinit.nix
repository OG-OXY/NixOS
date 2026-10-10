{
  ...
}:
{
  flake.nixosModules.nirinit = { ... }:
  {
    services.nirinit = {
      enable = true;
      settings = {
        skip.apps = [ 
          "steam"
          "lutris"
        ];
      };
    };
  };
}
