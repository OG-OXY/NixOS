{
  ...
}:
{
  flake.nixosModules.nix = { ... }:
  {
    nix = {
      settings = {
        auto-optimise-store = true;
        download-buffer-size = 536870912;
        max-substitution-jobs = 128;
        trusted-users = [ "root" "ty" "@wheel" ];
        experimental-features = [ "nix-command" "flakes" ];
      };
      # Garbage collection.
      gc = {
        automatic = true;
        dates = "daily";
        options = "--delete-older-than 3d";
      };
    };
  };
}
