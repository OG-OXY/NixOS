{
  ...
}:
{
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = "Ty";
        email = "ogoxy.yt@gmail.com";
      };
      git = {
        auto-local-bookmark = true;
      };
      signing = {
        sign-all = true;
        backend = "ssh";
        key = "~/.ssh/id_ed25519.pub";
      };
      ui = {
        editor = "nvf";
        paginate = "never"; # or "auto"
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
}
