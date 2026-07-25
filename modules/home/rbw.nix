{
  pkgs,
  ...
}:
{
  programs.rbw = {
    enable = true;
    settings = {
      email = "ogoxy.yt@gmail.com";
      pinentry = pkgs.pinentry-gnome3;
      lock_timeout = 86400;
    };
  };
}
