{
  ...
}:
{
  flake.nixosModules.lite-llm = { pkgs, lib, ... }:
  let
    geminiKeys = [
      "GEMINI_KEY_1"
      "GEMINI_KEY_2"
      "GEMINI_KEY_3"
    ];

    mkGeminiDeployments = modelName: upstreamModel:
      map (keyVar: {
        model_name = modelName;
        litellm_params = {
          model = upstreamModel;
          api_key = "os.environ/${keyVar}";
        };
      }) geminiKeys;
  in  
  {
    services.litellm = {
      enable = true;
      host = "127.0.0.1"; # Keep it bound locally on loopback
      port = 4000;         # Standard proxy listening port
      package = pkgs.litellm;
      settings = {
        litellm_settings = {
          detailed_debug = true;
        };

        general_settings = {
          master_key = "os.environ/LITELLM_MASTER_KEY";
          dangerously_permit_weak_or_unset_master_key = true;
        };

        router_settings = {
          routing_strategy = "simple-shuffle";
          num_retries = builtins.length geminiKeys;
          allowed_fails = 1;
          cooldown_time = 18000; # 5 hours in seconds after a 429 quota hit
        };

        model_list = [
          {
            model_name = "qwen2.5-coder:14B";
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
            model_name = "qwen2.5-coder:32B";
            litellm_params = {
              model = "openai/qwen-32b";
              api_base = "http://127.0.0.1:8080/v1";
              api_key = "os.environ/LLAMA_API_KEY";
              custom_llm_provider = "openai";
            };
            model_info = {
              supports_function_calling = true;
              # supported_openai_params = [ "tools" "tool_choice" "temperature" "max_tokens" ];
            };
          }
        ] ++ (mkGeminiDeployments "gemini-flash" "gemini/gemini-3.8-flash");
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
