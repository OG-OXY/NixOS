{
  ...
}:
{
  flake.nixosModules.network = { config, ... }:
  {
    networking = {
      hostName = "nixos";
      nameservers = [ 
        "1.1.1.1"
        "1.0.0.1"
        "9.9.9.9"
      ];
      networkmanager = {
        enable = true;
        wifi = {
          backend = "iwd";
          powersave = false;
        };
        dns = "dnsmasq";
        ensureProfiles = {
          environmentFiles = [ config.sops.templates."WIFI_PSK.env".path ];
          profiles = {
            "Home-WIFI" = {
              connection = {
                id = "Home-WIFI";
                type = "wifi";
                autoconnect = true;
              };
              wifi = {
                ssid = "JOSH3881";
                bssid = "7C:9A:54:AF:D7:22";
                interface-name = "wlan0";
                mode = "infrastructure";
                band = "bg";
                powersave = 2;
              };
              wifi-security = {
                key-mgmt = "wpa-psk";
                psk = "$WIFI_PSK"; #SOPS secret
              };
              ipv4 = {
                method = "auto";
                ignore-auto-dns = true;
              };
              ipv6 = {
                addr-gen-mode = "default";
                method = "auto";
                ignore-auto-dns = true;
              };
            };
          };
        };
      };
      firewall = {
        allowedTCPPorts = [ 22 ];
        trustedInterfaces = [ "tailscale0" ];
      };
      wireless = {
        enable = false;
        iwd = {
          enable = true;
          settings = {
            General = {
              EnableNetworkConfiguration = false;
            };
            Rank = {
              BandModifier5GHz = 0.0;
              "BandModifier2.4GHz" = 10.0;
            };
          };
        };
      };
    };
  };
}
