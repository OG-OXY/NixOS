# emacs.nix
{
  inputs,
  ...
}:
{
  flake.nixosModules.emacs = { pkgs, ... }:
  let
    emacs = (pkgs.emacsPackagesFor pkgs.emacs-pgtk).emacsWithPackages (epkgs:
    let
      fpkgs = pkgs.mkFpkg epkgs;
    in
    [
      epkgs.use-package
      epkgs.no-littering
      epkgs.doom-themes
      epkgs.doom-modeline
      epkgs.dashboard
      epkgs.nerd-icons
      epkgs.helix
      epkgs.which-key
      epkgs.vertico
      epkgs.marginalia
      epkgs.consult
      epkgs.perspective
      epkgs.projectile
      epkgs.orderless
      epkgs.corfu
      epkgs.org-roam
      epkgs.org-appear
      epkgs.org-modern
      epkgs.org-superstar
      epkgs.sqlite3
      epkgs.emacsql
      epkgs.forge
      epkgs.pandoc-mode
      epkgs.undo-fu-session
      epkgs.helpful
      epkgs.treesit-grammars.with-all-grammars
      (fpkgs "helix" inputs.helix-mode [ ])
      (fpkgs "image-roll" inputs.image-roll [ ])
      (fpkgs "majutsu" inputs.majutsu [
        epkgs.magit
        epkgs.consult
        epkgs.plz
        epkgs.transient
      ])
    ]);
  in
  {
    environment = {
      systemPackages = [ emacs ];
      pathsToLink = [ "/share" "/share/emacs" "/share/applications" ];
    };
    # Launch the isolated tinkering service
    systemd.user.services.emacs = {
      description = "Emacs PGTK Daemon";
      documentation = [ "info:emacs" "man:emacs(1)" "https://gnu.org/software/emacs/" ];
      wantedBy = [ "default.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${emacs}/bin/emacs --init-directory=%h/NixOS/Modules/Features/emacs/emacs.d --fg-daemon=emacs";
        ExecStop = "${emacs}/bin/emacsclient -s emacs -e '(kill-emacs)'";
        Restart = "on-failure";
        SuccessExitStatus = 15;
      };
    };
  };
}
