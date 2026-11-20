# emacs.nix
{
  inputs,
  ...
}:
{
  flake.homeModules.emacs = { pkgs, config, ... }:
  let
    cfg = config.programs.emacs;
    HOME = config.home.homeDirectory;
  in
  {
    programs.emacs = {
      enable = true;
      package = pkgs.emacs-pgtk;
      extraPackages = epkgs: let
        fpkg = pkgs.mkFpkgs epkgs;
      in
      [
        epkgs.use-package
        epkgs.no-littering
        epkgs.doom-themes
        epkgs.doom-modeline
        epkgs.dashboard
        epkgs.nerd-icons
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
        (fpkg "image-roll" inputs.image-roll [ ])
        (fpkg "majutsu" inputs.majutsu [
          epkgs.magit
          epkgs.consult
          epkgs.plz
          epkgs.transient
        ])
        (fpkg "helix" inputs.helix-mode [ ])
      ];
    };
    services.emacs = {
      enable = true;
      package = cfg.finalPackage;
      client.enable = true;
      startWithUserSession = true;
      extraOptions = [
        "--init-directory=${HOME}/NixOS/Modules/Features/emacs/emacs.d"
      ];
    };
  };
}
