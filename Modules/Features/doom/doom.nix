# doom.nix
{
 inputs,
  ...
}:
{
  flake.nixosModules.doom = { pkgs, ... }:
  let
    doom = pkgs.doomEmacs {
      doomDir = ./doom.d;
      doomLocalDir = "~/.local/share/doom";
      emacs = pkgs.emacs-pgtk;
      experimentalFetchTree = true;
      extraPackages = epkgs:
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
    };
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
# Extra Configurations + Disabled, Changed
# tangleArgs = "--all config.org";
