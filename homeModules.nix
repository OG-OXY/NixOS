#homeModules.nix
{...}: {
  imports = [
    ./Home/ai-chat.nix
    ./Home/atuin.nix
    ./Home/ghostty.nix
    ./Home/fish.nix
    ./Home/scripts.nix
    ./Home/hyprland-permissions.nix
    ./Home/github-cli.nix
    ./Home/jujutsu.nix
    ./Home/ssh.nix
    ./Home/rbw.nix
    ./Home/fastfetch.nix
  ];
}
