{
  ...
}:
{
  flake.homeModules.emacs = { pkgs, ... }:
  {
    programs.doom-emacs = {
      enable = false;
      doomDir = ./doom.d;
      emacs = pkgs.emacs-pgtk;
      provideEmacs = true;
    };
    services.emacs = {
      enable = true;
      client.enable = true;
    };
  };
  flake.nixosModules.emacs = { pkgs, ... }:
  {
    environment.systemPackages = [
      (pkgs.doomEmacs {
        doomDir = ./doom.d;
        doomLocalDir = "~/.local/share/nix-doom";
        emacs = pkgs.emacs-pgtk;
      })
    ];
    services.emacs.enable = true;
  };
}
