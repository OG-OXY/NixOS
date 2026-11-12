{
  ...
}:
{
  flake.nixosModules.users = { pkgs, ... }:
  {
    users = {
      mutableUsers = true;
      users.root.shell = pkgs.nushell;
      users.ty = {
        shell = pkgs.nushell;
        isNormalUser = true;
        extraGroups = [
          "wheel"
          "networkmanager"
          "video"
          "render"
          "input"
          "uinput"
          "plugdev"
          "audio"
          "gamemode"
          "i2c"
          "libvirtd"
          "kvm"
          "vboxusers"
          "wireshark"
          "tcpdump"
        ];
      };
    };
  };
}
