{
  ...
}:
{
  flake.nixosModules.ollama = { pkgs, ... }:
  {
    services.ollama = {
      enable = true;
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
    systemd.services.ollama = {
      wantedBy = pkgs.lib.mkForce [ ];
    };
  };
}
