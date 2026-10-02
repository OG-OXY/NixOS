{
  ...
}:
{
  flake.nixosModules.git = { ... }:
  {
    programs.git = {
      enable = true;
      lfs.enable = true;
      config = {
        user = {
          name = "Ty";
          email = "ogoxy.yt@gmail.com";
        };
        gpg.format = "ssh";
        init.defaultBranch = "master";
        commit.gpgsign = true;
        user.signingKey = "/home/ty/.ssh/id_ed25519.pub";
      };
    };
  };
}
