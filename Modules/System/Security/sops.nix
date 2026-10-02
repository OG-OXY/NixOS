{
  ...
}:
{
  flake.nixosModules.sops = { config, ... }:
  {
    sops = {
      defaultSopsFile = "/home/ty/NixOS/secrets.yaml";
      defaultSopsFormat = "yaml";
      validateSopsFiles = false;
      age = {
        keyFile = "/home/ty/.config/sops/age/keys.txt";
        sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      };
      secrets = {
        "GITHUB_TOKEN" = {
          owner = "ty";
          group = "users";
          mode = "0400";
        };
        "GOOGLE_API_KEY" = {
          owner = "ty";
          group = "users";
          mode = "0400";
        };
        "GEMINI_API_KEY" = {
          owner = "ty";
          group = "users";
          mode = "0400";
        };
        "WIFI_PSK" = {
          owner = "root";
          group = "root";
          mode = "0400";
        };
        "bw_client_id" = {
          owner = "ty";
          group = "users";
          mode = "0400";
        };
        "bw_client_secret" = {
          owner = "ty";
          group = "users";
          mode = "0400";
        };
      };
      templates = {
        "secrets.env" = {
          owner = "ty";
          group = "users";
          mode = "0400";
          content = ''
            GITHUB_TOKEN=${config.sops.placeholder.GITHUB_TOKEN}
            GOOGLE_API_KEY=${config.sops.placeholder.GOOGLE_API_KEY}
            GEMINI_API_KEY=${config.sops.placeholder.GOOGLE_API_KEY}
            BW_CLIENTID=${config.sops.placeholder.bw_client_id}
            BW_CLIENTSECRET=${config.sops.placeholder.bw_client_secret}
          '';
        };
        "WIFI_PSK.env" = {
          owner = "root";
          group = "root";
          mode = "0400";
          content = ''
            WIFI_PSK=${config.sops.placeholder.WIFI_PSK}
          '';
        };
      };
    };
  };
}
