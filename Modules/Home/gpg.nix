{
  pkgs,
  ...
}:
{
  services.gpg-agent = {
    enable = true;
    enableExtraSocket = true;
    enableSshSupport = false;
    defaultCacheTtl = 28800; # 8 hours
    maxCacheTtl = 86400; # 24 hours
    pinentry = {
      package = pkgs.pinentry-qt;
    };
    extraConfig = ''
      allow-loopback-pinentry
    '';
  };
}
