{
  ...
}:
{
  # flake.homeModules.doom = { pkgs, ... }:
  # {
  #   programs.doom-emacs = {
  #     enable = true;
  #     doomDir = ./doom.d;
  #     emacs = pkgs.emacs-pgtk;
  #     provideEmacs = true;
  #     experimentalFetchTree = true;
  #   };

  #   services.emacs = {
  #     enable = true;
  #     client.enable = true;
  #   };
  # };
  flake.nixosModules.doom = { pkgs, ... }:
  let
    Doom = pkgs.emacsWithDoom {
      doomDir = ./doom.d;
      doomLocalDir = "~/.local/share/doom";
      emacs = pkgs.emacs-pgtk;
      experimentalFetchTree = true;
      # tangleArgs = "--all config.org";
      # extraPackages = epkgs: [
      #   epkgs.treesit-grammars.with-all-grammars
      # ];
    };
  in
  {
    environment = {
      systemPackages = [
        Doom
      ];
      pathsToLink = [
        "/share/applications"
        "/share/emacs"
      ];
    };

    systemd.user.services.doom = {
      description = "Doom Emacs Daemon";
      documentation = [ "info:emacs" "man:emacs(1)" "https://gnu.org/software/emacs/" ];
      wantedBy = [ "default.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.bash}/bin/bash -l -c '${Doom}/bin/emacs --fg-daemon'";
        ExecStop = "${pkgs.bash}/bin/bash -l -c  '${Doom}/bin/emacsclient --eval \"(kill-emacs)\"'";
        Restart = "on-failure";
        SuccessExitStatus = 15;
        Type = "notify";
      };
    };

    xdg.desktopEntries = {
      emacsclient = {
        name = "Emacs Client";
        genericName = "Text Editor";
        comment = "Edit text";
        exec = "${Doom}/bin/emacsclient -c -a \"emacs\"";
        # OR
        # exec = "/nix/store/[a-z0-9]{32}-emacs-pgtk-with-doom-[0-9.]*/bin/emacsclient -c -a 'emacs'";
        icon = "emacs";
        terminal = false;
        type = "Application";
        categories = [ "TextEditor" "Development" ];
        mimeType = [
          "text/english"
          "text/plain"
          "text/x-makefile"
          "text/x-c++hdr"
          "text/x-c++src"
          "text/x-chdr"
          "text/x-csrc"
          "text/x-java"
          "text/x-moc"
          "text/x-pascal"
          "text/x-tcl"
          "text/x-tex"
          "application/x-shellscript"
          "text/x-c"
          "text/x-c++"
        ];
        settings = {
          Keywords = "Text;Editor";
          StartupWMClass = "Emacsd";
        };
      };
      emacsclient-mail = {
        categories = [ "Network" "Email" ];
        comment = "GNU Emacs is an extensible, customizable text editor - and more";
        exec = ''${pkgs.emacs-pgtk}/bin/emacsclient --alternate-editor= --eval "(message-mailto (pop server-eval-args-left))" %u '';
        icon = "emacs";
        name = "Emacs (Mail, Client)";
        mimeType = "x-scheme-handler/mailto";
        noDisplay = "true";
        terminal = "false";
        type = "Application";
        settings = {
          Keywords = "emacsclient";
        };
        actions = {
          "new-window" = {
              exec = ''${pkgs.emacs-pgtk}/bin/emacsclient --alternate-editor= --create-frame --eval "(message-mailto (pop server-eval-args-left))" %u'';
            };
          "new-instance" = {
            exec = ''${pkgs.emacs-pgtk}/bin/emacsclient --alternate-editor= --create-frame --eval "(message-mailto (pop server-eval-args-left))" %u'';
          };
        };
      };
    };
  };
}
# Extra Configurations + Disabled, Changed
# tangleArgs = "--all config.org";
# extraPackages = epkgs: [
#   epkgs.treesit-grammars.with-all-grammars
# ];
# wantedBy = [ "graphical-session.target" ];
# partOf = [ "graphical-session.target" ];
