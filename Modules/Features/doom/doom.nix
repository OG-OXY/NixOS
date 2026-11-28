# doom.nix
{
 inputs,
  ...
}:
{
  flake.nixosModules.doom = { pkgs, lib, ... }:
  let
    doomDirPath = ./doom.d;
    orgFiles = map
      (file: lib.removePrefix "${toString doomDirPath}/" (toString file))
      (lib.fileset.toList (lib.fileset.fileFilter (f: f.hasExt "org") doomDirPath));
    doom = pkgs.doomEmacs (
      {
        doomDir = doomDirPath;
        doomLocalDir = "~/.local/share/doom";
        emacs = pkgs.emacs-pgtk;
        experimentalFetchTree = true;
        extraPackages =
          epkgs:
          let
            fpkgs = pkgs.mkFpkg epkgs;
          in
          [
            epkgs.treesit-grammars.with-all-grammars
            (fpkgs "helix" inputs.helix-mode [ ])
            (fpkgs "image-roll" inputs.image-roll [ ])
            (fpkgs "majutsu" inputs.majutsu [
              epkgs.magit
              epkgs.consult
              epkgs.plz
              epkgs.transient
            ])
          ];
      }
      // lib.optionalAttrs (orgFiles != [ ]) {
        tangleArgs = "--all ${builtins.concatStringsSep " " orgFiles}";
      }
    );
  in
  {
    environment.systemPackages = [ doom ];
    systemd.user.services.doom = {
      description = "Doom Emacs Daemon";
      documentation = [ "info:emacs" "man:emacs(1)" "https://gnu.org/software/emacs/" ];
      wantedBy = [ "default.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${doom}/bin/doom-emacs --fg-daemon=doom";
        ExecStop = "${pkgs.emacs-pgtk}/bin/emacsclient -s doom -e '(kill-emacs)'";
        Restart = "on-failure";
        SuccessExitStatus = 15;
      };
    };
  };
}
