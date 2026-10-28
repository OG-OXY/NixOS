{
 inputs,
  ...
}:
{
  # flake.homeModules.doom = { pkgs, ... }:
  # {
  #   programs.doom-emacs = {
  #     enable = true;
  #     doomDir = ./doom.d;
  #     doomLocalDir = "/home/ty/.local/share/doom";
  #     emacs = pkgs.emacs-pgtk;
  #     # provideEmacs = false;
  #     experimentalFetchTree = true;
  #     extraPackages = epkgs: [
  #       epkgs.treesit-grammars.with-all-grammars
  #       (epkgs.melpaBuild {
  #         pname = "image-roll";
  #         version = "1.0.0";
  #         packageRequires = [ ]; 
  #         src = inputs.image-roll;
  #       })
  #       (epkgs.melpaBuild {
  #         pname = "majutsu";
  #         version = "1.0.0";
  #         packageRequires = [
  #           epkgs.magit
  #           epkgs.consult 
  #           epkgs.plz 
  #           epkgs.transient
  #         ]; # Majutsu requires Magit (which Doom enables via :tools magit)
  #         src = inputs.majutsu;
  #       })
  #       # (epkgs.melpaBuild {
  #       #   pname = "hel";
  #       #   version = "1.0.0";
  #       #   packageRequires = [
  #       #     epkgs.dash
  #       #     epkgs.avy
  #       #     epkgs.pcre2el
  #       #     epkgs.ultra-scroll
  #       #   ]; 
  #       #   src = inputs.hel;
  #       # })
  #     ];
  #   };

  #   services.emacs = {
  #     enable = true;
  #   };
  # };
  flake.nixosModules.doom = { pkgs, ... }:
  let
    doom = pkgs.doomEmacs {
      doomDir = ./doom.d;
      doomLocalDir = "~/.local/share/doom";
      emacs = pkgs.emacs-pgtk;
      experimentalFetchTree = true;
      extraPackages = epkgs:
      let
        fpkgs = pname: src: packageRequires: epkgs.melpaBuild {
          inherit pname src packageRequires;
          version = "1.0.0";
        };
      in
      [
        epkgs.treesit-grammars.with-all-grammars
        (fpkgs "image-roll" inputs.image-roll [ ])
        (fpkgs "majutsu" inputs.majutsu [ epkgs.magit epkgs.consult epkgs.plz epkgs.transient ])
      ];
    };
  in
  {
    environment = {
      systemPackages = [
        doom
      ];
      pathsToLink = [
        "/share"
        "/share/applications"
      ];
    };

    systemd.user.services.doom = {
      description = "Doom Emacs Daemon";
      documentation = [ "info:emacs" "man:emacs(1)" "https://gnu.org/software/emacs/" ];
      wantedBy = [ "default.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "notify";
        ExecStart = "${pkgs.emacs-pgtk}/bin/emacs --init-directory=${doom}/bin/doom --fg-daemon=doom";
        ExecStop = "${pkgs.emacs-pgtk}/bin/emacsclient --socket-name=doom --eval '(kill-emacs)'";
        Restart = "on-failure";
        SuccessExitStatus = 15;
      };
    };
  };
}
# Extra Configurations + Disabled, Changed
# tangleArgs = "--all config.org";
# (fpkgs "hel" inputs.hel [ epkgs.dash epkgs.avy epkgs.pcre2el epkgs.ultra-scroll ])
