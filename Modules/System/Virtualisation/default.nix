{
  ...
}:
{
  flake.nixosModules.virtualisation = { pkgs, ... }:
  {
    virtualisation = {
      vmVariant = {
        users.users = {
          ty.password = "test";
          root.password = "test";
        };
        virtualisation = {
          memorySize = 8192;
          cores = 8;
          qemu.options = [ "-device virtio-vga-gl -display gtk,gl=on" ];
        };
      };
      libvirtd = {
        enable = true;
        onBoot = "ignore";
        onShutdown = "shutdown";
        qemu = {
          package = pkgs.qemu_kvm;
          runAsRoot = true;
        };
      };
      podman = {
        enable = true;
        dockerCompat = true;
      };
      containers.enable = true;
      oci-containers = {
        backend = "podman";
        containers = {
          #unsloth-proxy = {
          # image = "docker.io/unsloth/unsloth:latest";
          # autoStart = true;
          # ports = [ "4000:4000" ];
          # extraOptions = [ "--network=host" ];
          # cmd = [
          #   "unsloth run \
          #    -H 127.0.0.1 \
          #     -p 4000"
          #  ];
          #};
        };
      };
    };
  };
}
