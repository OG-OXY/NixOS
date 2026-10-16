{
  ...
}:
{
  flake.nixosModules.llama-cpp = { pkgs, lib, ... }:
  let
    grammarFile = ./tools.gbnf;
    jsonSchema = ./tooling.json;
  in
  {
    services.llama-cpp = {
      enable = true;
      settings = {
        # hf-repo = "Qwen/Qwen2.5-Coder-32B-Instruct-GGUF";
        # hf-file = "qwen2.5-coder-32b-instruct-q4_k_m.gguf";
        hf-repo = "Qwen/Qwen2.5-Coder-14B-Instruct-GGUF";
        hf-file = "qwen2.5-coder-14b-instruct-q4_k_m.gguf";
        host = "127.0.0.1";
        port = 8012;
        jinja = true;
        flash-attn = "on";
        cache-type-k = "q8_0";
        cache-type-v = "q8_0";
        # ctx-size = 32768;
        ctx-size = 12288;
        n-gpu-layers = 30;
        threads = 8;
        temp = 0.2;
        repeat-penalty = 1.05;
        grammar-file = "${grammarFile}";
        json-schema-file = "${jsonSchema}";
      };
      package =
        (pkgs.llama-cpp.override {
          cudaSupport = true;
        }).overrideAttrs
          (oldAttrs: {
            nativeBuildInputs = (oldAttrs.nativeBuildInputs or []) ++ [
              pkgs.cudaPackages_12.cudatoolkit
              pkgs.cudaPackages_12.cuda_nvcc        
            ];
            cmakeFlags = (oldAttrs.cmakeFlags or [ ]) ++ [
              "-DGGML_CUDA=ON"
              "-DCMAKE_CUDA_ARCHITECTURES=61"
              "-DGGML_CUDA_FORCE_MMQ=ON"
              "-DGGML_CUDA_FA_ALL_QUANTS=ON"
            ];
          });
    };
    systemd.services.llama-cpp = {
      wantedBy = lib.mkForce [];
      # serviceConfig = {
      # };
    };
  };
}
