{
  ...
}:
{
  flake.nixosModules.llama-cpp = { pkgs, lib, ... }:
  let
    modelsIni = ./models-preset.ini;
    opencodeConfig = ../agent/opencode-config.json;
    gooseConfig = ../agent/goose-config.yaml;
    # grammarFile = ./tools.gbnf;
    # jsonSchema = ./tooling.json;
  in
  {
    services.llama-cpp = {
      enable = true;
      settings = {
        models-preset = "${modelsIni}";
        host = "0.0.0.0";
        port = 8080;
        jinja = true;
        # chat-template = "chatml";
        ctx-size = 16384;
        temp = 0.6;
        repeat-penalty = 1.00;
        api-key = "$LLAMA_API_KEY";
        # reasoning-format = "none";
        reasoning = "off";
        log-verbosity = 4;
        no-warmup = true;
        # verbose = true; # Sets Verbosity To Infinity.
        # log-format = "text";
        # ctx-size = 12288;
        # ctx-size = 65536;
        # grammar-file = "${grammarFile}";
        # json-schema-file = "${jsonSchema}";
      };
      package = pkgs.llama-cpp-cuda.overrideAttrs (oldAttrs: {
        cmakeFlags = (oldAttrs.cmakeFlags or [ ]) ++ [
          "-DGGML_CUDA=ON"
          "-DGGML_NATIVE=ON"
          "-DCMAKE_CUDA_ARCHITECTURES=61"
          "-DGGML_CUDA_FORCE_MMQ=ON"
          "-DGGML_CUDA_FA_ALL_QUANTS=ON"
        ];
      });
    };
    systemd = {
      services.llama-cpp = {
        wantedBy = lib.mkForce [ ];
        # requires = [ "litellm.service" ];
        environment = {
          GGML_CUDA_DISABLE_GRAPHS = "1";
        };
        serviceConfig = {
          EnvironmentFile = "/run/secrets/rendered/secrets.env";
        };
      };
      tmpfiles.rules = [
        "d /home/ty/.config/goose 0755 ty users -"
        "d /home/ty/.config/opencode 0755 ty users -"
        "C+ /home/ty/.config/goose/config.yaml 0644 ty users - ${gooseConfig}"
        "L+ /home/ty/.config/opencode/opencode.json 0644 ty users - ${opencodeConfig}"
      ];
    };
  };
}
