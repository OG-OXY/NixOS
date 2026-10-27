{
  inputs,
  ...
}:
{
  flake.nixosModules.emacs = { pkgs, ... }:
  let
    emacsDir = ./emacs.d;
    emacs = (pkgs.emacsPackagesFor pkgs.emacs-pgtk).emacsWithPackages (epkgs:
    let
      fpkgs = pname: src: packageRequires: epkgs.melpaBuild {
        inherit pname src packageRequires;
        version = "1.0.0";
      };
    in
    [
      epkgs.use-package
      # epkgs.evil
      # epkgs.evil-mc
      epkgs.doom-themes
      epkgs.doom-modeline
      epkgs.vertico
      epkgs.marginalia
      epkgs.consult
      epkgs.orderless
      epkgs.corfu
      epkgs.corfu-terminal
      epkgs.org-roam
      epkgs.org-appear
      epkgs.org-modern
      epkgs.org-superstar
      epkgs.pandoc-mode
      epkgs.undo-fu-session
      epkgs.treesit-grammars.with-all-grammars
      (fpkgs "image-roll" inputs.image-roll [ ])
      (fpkgs "majutsu" inputs.majutsu [ epkgs.magit epkgs.consult epkgs.plz epkgs.transient ])
      (fpkgs "hel" inputs.hel [ epkgs.dash epkgs.avy epkgs.pcre2el epkgs.ultra-scroll ])
    ]);
  in
  {
    environment.systemPackages = [ emacs ];
    # Launch the isolated tinkering service
    systemd.user.services.emacs-pgtk = {
      description = "Emacs PGTK Daemon";
      wantedBy = [ "default.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${emacs}/bin/emacs --init-directory=${emacsDir} --fg-daemon=emacs";
        ExecStop = "${emacs}/bin/emacsclient --socket-name=emacs --eval '(kill-emacs)'";
        Restart = "on-failure";
      };
    };    
  };
}
