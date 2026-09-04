{
  pkgs,
  ...
}:
{
  programs.rbw = {
    enable = true;
    settings = {
      email = "ogoxy.yt@gmail.com";
      pinentry = pkgs.pinentry-qt;
      lock_timeout = 86400;
    };
  };
}
