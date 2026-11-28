{
  ...
}:
{
  flake.nixosModules.wlr-which-key = {  ... }:
  {
    programs.wlr-which-key = {
      enable = true;
      settings = {
        anchor = "center";
        font = "JetBrainsMono NFM 20";
      };
      menus = {
        warp = [
          {
            key = "d";
            desc = "Run (Normal Mode)";
            cmd = "uwsm app -- warpd  --normal";
          }
          {
            key = "h";
            desc = "Hint Mode";
            cmd = "uwsm app -- warpd --hint";
          }
          {
            key = "q";
            desc = "Quadrant Mode";
            cmd = "uwsm app -- warpd --grid";
          }
        ];
        apps = [
          {
            key = "l";
            desc = "Launcher";
            cmd = "noctalia msg panel-toggle launcher";
          }
          {
            key = "h";
            desc = "Herdr";
            cmd = "uwsm app -- ghostty -e herdr";
          }
          {
            key = "g";
            desc = "Ghostty";
            cmd = "uwsm app -- ghostty";
          }
          {
            key = "z";
            desc = "Zen-Browser";
            cmd = "uwsm app -- zen-beta";
          }
          {
            key = "d";
            desc = "Doom Client";
            cmd = "uwsm app -- emacsclient -s doom -c";
          }
          {
            key = "c";
            desc = "Emacs Client";
            cmd = "uwsm app -- emacsclient -s emacs -c";
          }
          {
            key = "o";
            desc = "Obsidian";
            cmd = "uwsm app -- obsidian /home/ty/Notes/Obsidian";
          }
          {
            key = "v";
            desc = "Vesktop";
            cmd = "uwsm app -- vesktop";
          }
          {
            key = "s";
            desc = "OBS-Studio";
            cmd = "uwsm app -- obs";
          }
          {
            key = "b";
            desc = "Bitwarden";
            cmd = "uwsm app -- bitwarden";
          }
          {
            key = "e";
            desc = "EasyEffects";
            cmd = "uwsm app -- easyeffects";
          }
          # {
          #   key = "y";
          #   desc = "Yazi";
          #   cmd = "${pkgs.ghostty}/bin/ghostty -e ${pkgs.fish}/bin/fish -i -C 'y'";
          # }
        ];
      };
    };
  };
}
