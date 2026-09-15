#systemModules.nix
{
  ...
}:
{
  imports = [
    ./Modules/Hardware/hardware.nix
    ./Modules/Hardware/nvidia.nix
    ./nixosModules.nix
  ];
}
