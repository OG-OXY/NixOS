# doom.nix
{
 inputs,
  ...
}:
{
  flake.homeModules.doom = { pkgs, config, ... }:
  let
    cfg = config.programs.doom-emacs;
    localDir = "${config.xdg.dataHome}/doom";
  in
  {
    programs.doom-emacs = {
      enable = true;
      doomDir = ./doom.d;
      doomLocalDir = localDir;
      emacs = pkgs.emacs-pgtk;
      provideEmacs = false;
      experimentalFetchTree = true;
      extraPackages = epkgs: let
        fpkg = pkgs.mkFpkgs epkgs;
      in
      [
        epkgs.treesit-grammars.with-all-grammars
        (fpkg "image-roll" inputs.image-roll [ ])
        (fpkg "majutsu" inputs.majutsu [ epkgs.magit epkgs.consult epkgs.plz epkgs.transient ])
        (fpkg "helix" inputs.helix-mode [ ])
      ];
    };
    systemd.user.services.doom = {
      Unit = {
        Description = "Doom Emacs Daemon";
        After = [ "graphical-session.target" ];
      };
      Service = {
        Type = "simple";
        ExecStart = "${cfg.finalDoomPackage}/bin/doom-emacs --fg-daemon=doom";
        ExecStop = "${pkgs.emacs-pgtk}/bin/emacsclient -s doom --eval '(kill-emacs)'";
        Restart = "on-failure";
      };
      Install = {
        WantedBy = [ "default.target" ];
      };     
    };
    xdg.desktopEntries.doom = {
      name = "Doom Emacs";
      genericName = "Text Editor";
      comment = "Edit text and code with Doom Emacs";
      exec = "${pkgs.emacs-pgtk}/bin/emacsclient -s doom -c -n -a \"${config.programs.doom-emacs.finalDoomPackage}/bin/doom-emacs --fg-daemon=doom\" %F";
      icon = "emacs";
      terminal = false;
      categories = [ "TextEditor" "Development" ];
      mimeType = [ "text/english" "text/plain" "text/x-makefile" "text/x-c++hdr" "text/x-c++src" "text/x-chdr" "text/x-csrc" "text/x-java" "text/x-moc" "text/x-pascal" "text/x-tcl" "text/x-tex" "application/x-shellscript" "text/x-c" "text/x-c++" ];
      startupNotify = true;      
    };
  };
}
# Extra Configurations + Disabled, Changed
# tangleArgs = "--all config.org";
