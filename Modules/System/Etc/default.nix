{
  ...
}:
{
  flake.nixosModules.etc = { lib, ... }:
  {
    environment.etc = {
      "NetworkManager/dnsmasq.d/fallback-dns.conf".text = ''
        no-resolv
        server=1.1.1.1
        server=1.0.0.1
        server=9.9.9.9
        all-servers
      '';
      "greetd/sway-config".text = lib.mkForce ''
        exec regreet
        output "ASUSTek COMPUTER INC ROG PG258Q ASP9OUVfHcfd" mode 1920x1080@240 pos 0 0
        output "Dell Inc. DELL P2720D K6RX299P10LS" mode 2560x1440@59 pos 1920 -180
        seat * hide_cursor 3000
      '';
      #OBS DEBUGGING
      "xdg/xdg-desktop-portal-wlr/config".text = ''
        [screencast]
        force_linear = true
      '';
    };
  };
}
