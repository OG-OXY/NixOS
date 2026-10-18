{
  ...
}:
{
  flake.nixosModules.lite-llm = { pkgs, lib, ... }:
  {
    services.litellm = {
      enable = true;
      host = "127.0.0.1"; # Keep it bound locally on loopback
      port = 4000;         # Standard proxy listening port
      package = pkgs.litellm;
      settings = {
        litellm_settings = [
          "detailed_debug=True"
        ];
        model_list = [
          {
            model_name = "qwen2.5-coder:14b";
            litellm_params = {
              model = "openai/qwen-14b";
              api_base = "http://127.0.0.1:8080/v1";
              api_key = "os.environ/LLAMA_API_KEY";
              custom_llm_provider = "openai";
            };
            model_info = {
              supports_function_calling = true;
              # supported_openai_params = [ "tools" "tool_choice" "temperature" "max_tokens" ];
            };
          }
          {
            model_name = "gemini-flash";
            litellm_params = {
              model = "gemini/gemini-1.5-flash";
              # Tells LiteLLM to grab the secret token directly from systemd environment rules
              api_key = "os.environ/GEMINI_API_KEY"; 
            };
          }
        ];
      };
    };

    systemd.services.litellm = {
      wantedBy = lib.mkForce [ ];
      # requiredBy = lib.mkForce [ "llama-cpp.service" ];
      # requiredBy = []; # Opposite Of wantedBy, RequiredBy Is A Hard Requirement, So Litellm Cannot Start If Llama-cpp Fails.
      after = [ "llama-cpp.service" ]; # Ensure llama-server finishes compilation boots first
      # Ensures Litellm Stops When Llama Is.
      # bindsTo = [ "llama-cpp.service" ];
      # requires = [ "llama-cpp.service" ]; # Hard Requirement, Litellm Cannot Start If This Service Is Not Running
      serviceConfig = {
        # Use an environment file path to inject your Gemini cloud secrets safely 
        EnvironmentFile = "/run/secrets/rendered/secrets.env"; 
      };
    };
  };
}
