{ ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "*" = {
        IdentityAgent = "~/.bitwarden-ssh-agent.sock";
      };

      "NixOS" = {
        HostName = "100.99.131.97";
        Port = 22;
        User = "ty";
        StrictHostKeyChecking = "no";
        RequestTTY = "yes";
        UserKnownHostsFile = "/dev/null";
      };

      "Nix-On-Droid" = {
        HostName = "100.71.190.30";
        Port = 8022;
        User = "nix-on-droid";
        StrictHostKeyChecking = "no";
        RequestTTY = "yes";
        UserKnownHostsFile = "/dev/null";
      };
    };
  };
}
