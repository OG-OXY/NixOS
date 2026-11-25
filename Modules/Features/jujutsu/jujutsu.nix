{
  ...
}:
{
  flake.homeModules.jujutsu = { ... }:
  {
    programs.jujutsu = {
      enable = true;
      settings = {
        user = {
          name = "Ty";
          email = "ogoxy.yt@gmail.com";
        };
        signing = {
          behavior = "own";
          backend = "ssh";
          key = "~/.ssh/id_ed25519.pub";
        };
        ui = {
          editor = "hx";
          paginate = "auto";
          color = "always";
          default-command = [ "log" ];
          streampager = {
            show-ruler = true;
          };
        };
        git = {
          auto-local-bookmark = true;
          push = "origin";
        };
        revsets = {
          git-push = "master | exp";
        };
        fsmonitor = {
          backend = "watchman";
          watchman = {
            register-snapshot-trigger = true;
          };
        };
        snapshot = {
          auto-update-stale = true;
          max-new-file-size = "99999999";
        };
        aliases = {
          s = [ "status" ];
          l = [
            "log"
            "-r"
            "all()"
          ];
          d = [ "diff" ];
        };
      };
    };
  };
  flake.nixosModules.jjui = { pkgs, ... }:
  {
    environment.systemPackages = [
      pkgs.jj
      pkgs.jjui
      pkgs.jj-starship
    ];
  };
}
