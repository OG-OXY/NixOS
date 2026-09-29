#homeModules.nix
{...}: {
  imports = [
    ./Modules/Home/ai-chat.nix
    ./Modules/Home/atuin.nix
    ./Modules/Home/ghostty.nix
    ./Modules/Home/fish.nix
    ./Modules/Home/scripts.nix
    ./Modules/Home/hyprland-permissions.nix
    ./Modules/Home/github-cli.nix
    ./Modules/Home/jujutsu.nix
    ./Modules/Home/ssh.nix
    ./Modules/Home/rbw.nix
    ./Modules/Home/fastfetch.nix
  ];
}
