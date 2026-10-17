{
  ...
}:
{
  flake.nixosModules.ollama = { pkgs, ... }:
  let
    # qwenModelFile = ./modelfile;
  in
  {
    services.ollama = {
      enable = true;
      loadModels = [
        "qwen2.5-coder:14b"
        "qwen2.5-coder:32b"
      ];
      package = pkgs.ollama-cuda.overrideAttrs (oldAttrs: {
          cmakeFlags = (oldAttrs.cmakeFlags or [ ]) ++ [
            "-DCMAKE_CUDA_ARCHITECTURES=61"
          ];
      });
      environmentVariables = {
        CUDA_VISIBLE_DEVICES = "0";
        OLLAMA_GPU_OVERHEAD = "512";
      };
    };
    systemd.services = {
      ollama = {
        wantedBy = pkgs.lib.mkForce [ ];
      };
      # ollama-model-init = {
      #   description = "Initialize Ollama custom model context window";
      #   after = [ "ollama.service" ];
      #   requires = [ "ollama.service" ];
      #   wantedBy = [ "multi-user.target" ];
      #   serviceConfig = {
      #     Type = "oneshot";
      #     RemainAfterExit = true;
      #   };
      #   script = ''
      #     # Wait for the local ollama socket to respond
      #     until ${pkgs.curl}/bin/curl -s http://127.0.0.1:11434/api/tags >/dev/null 2>&1; do
      #       sleep 1
      #     done
      #     ${pkgs.ollama}/bin/ollama create qwen2.5-coder:14b -f ${qwenModelFile}
      #   '';
      # };
    };
  };
}
