{ pkgs, ... }:

let
  litellmConfigFile = pkgs.writeText "litellm-config.yaml" ''
    model_list:
      - model_name: "openai/Qwen"
        litellm_params:
          model: "openai/Qwen"
          api_base: "http://127.0.0.1:8012/v1"
          supports_function_calling: true
    litellm_settings:
      json_logs: false
      drop_params: true
  '';
in
{
  systemd.user.services.litellm-proxy = {
    Unit = {
      Description = "LiteLLM Proxy User Service";
      After = [ "network.target" ];
    };

    Service = {
      ExecStart = "${pkgs.litellm}/bin/litellm --config ${litellmConfigFile} --port 4000";
      Restart = "always";
      RestartSec = 3;
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
