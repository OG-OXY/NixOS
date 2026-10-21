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
      enable = false;
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
    };
  };
}
