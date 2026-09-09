#systemModules.nix
{
  ...
}:
{
  imports = [
    ./modules/hardware/hardware.nix
    ./modules/hardware/nvidia.nix
    ./nixosModules.nix
  ];
}
