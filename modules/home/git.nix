{ ... }:
{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Ty";
        email = "ogoxy.yt@gmail.com";
      };
      gpg.format = "ssh";
      init.defaultBranch = "master";
    };
    signing = {
      key = "~/.ssh/id_ed25519.pub";
      signByDefault = true;
    };
  };
}
