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
        "BW_CLIENTID" = {
          owner = "ty";
          group = "users";
          mode = "0400";
        };
        "BW_CLIENTSECRET" = {
          owner = "ty";
          group = "users";
          mode = "0400";
        };
        "GITHUB_TOKEN" = {
          owner = "ty";
          group = "users";
          mode = "0400";
        };
        "OBS_WEBSOCKET_URL" = {
          owner = "ty";
          group = "users";
          mode = "0400";
        };
        "LLAMA_API_KEY" = {
          owner = "ty";
          group = "users";
          mode = "0400";
        };
        "LITELLM_MASTER_KEY" = {
          owner = "ty";
          group = "users";
          mode = "0400";
        };
        "GEMINI_KEY_1" = {
          owner = "ty";
          group = "users";
          mode = "0400";
        };
        "GEMINI_KEY_2" = {
          owner = "ty";
          group = "users";
          mode = "0400";
        };
        "GEMINI_KEY_3" = {
          owner = "ty";
          group = "users";
          mode = "0400";
        };
        "GOOGLE_API_KEY" = {
          owner = "ty";
          group = "users";
          mode = "0400";
        };
        "GOOGLE_GENERATIVE_AI_API_KEY" = {
          owner = "ty";
          group = "users";
          mode = "0400";
        };
        "WIFI_PSK" = {
          owner = "root";
          group = "root";
          mode = "0400";
        };
      };
      templates = {
        "secrets.env" = {
          owner = "ty";
          group = "users";
          mode = "0400";
          content = ''
            BW_CLIENTID=${config.sops.placeholder.BW_CLIENTID}
            BW_CLIENTSECRET=${config.sops.placeholder.BW_CLIENTSECRET}
            GITHUB_TOKEN=${config.sops.placeholder.GITHUB_TOKEN}
            OBS_WEBSOCKET_URL=${config.sops.placeholder.OBS_WEBSOCKET_URL}
            LLAMA_API_KEY=${config.sops.placeholder.LLAMA_API_KEY}
            LITELLM_MASTER_KEY=${config.sops.placeholder.LITELLM_MASTER_KEY}
            GEMINI_KEY_1=${config.sops.placeholder.GEMINI_KEY_1}
            GEMINI_KEY_2=${config.sops.placeholder.GEMINI_KEY_2}
            GEMINI_KEY_3=${config.sops.placeholder.GEMINI_KEY_3}
            GOOGLE_API_KEY=${config.sops.placeholder.GOOGLE_API_KEY}
            GOOGLE_GENERATIVE_AI_API_KEY=${config.sops.placeholder.GOOGLE_GENERATIVE_AI_API_KEY}
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
