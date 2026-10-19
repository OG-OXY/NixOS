{
  ...
}:
{
  flake.nixosModules.gpg = { pkgs, ... }:
  let
    gpgAgentConf = pkgs.writeText "gpg-agent.conf" ''
      grab
      default-cache-ttl 28800
      max-cache-ttl 86400
      allow-loopback-pinentry
    '';
  in
  {
    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = false;
      enableExtraSocket = true;
      pinentryPackage = pkgs.pinentry-qt;
    };
    systemd.tmpfiles.rules = [
      "d /home/ty/.gnupg 0700 ty users -"
      "L+ /home/ty/.gnupg/gpg-agent.conf - - - - ${gpgAgentConf}"
    ];
  };
}
