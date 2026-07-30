{
  ...
}:
{
  home = {
    stateVersion = "26.11";
    sessionPath = [
      "$HOME/.local/bin"
    ];
    sessionVariables = {
      EDITOR = "nvf";
      VISUAL = "nvf";
    };
    file = {
      "secretspec.toml".source = ./config/secretspec/secretspec.toml;
      "NixOS/secretspec.toml".source = ./config/secretspec/secretspec.toml;
      ".config/tealdeer/config.toml".source = ./config/tealdeer/config.toml;
    };
  };

  xdg = {
    configFile = {
      "secretspec/config.toml".text = ''
        [defaults]
        provider = "keyring"
        profile = "default"
      '';
    };
    dataFile = {
      #
    };
  };

  systemd.user = {
    sessionVariables = {
      PINENTRY_USER_DATA = "gtk";
    };
  };

  imports = [
    ./modules/home/ghostty.nix
    ./modules/home/tmux.nix
    ./modules/home/fish.nix
    ./modules/home/atuin.nix
    ./modules/home/fastfetch.nix
    ./modules/home/yazi.nix
    ./modules/home/git.nix
    ./modules/home/github-cli.nix
    ./modules/home/jujutsu.nix
    ./modules/home/ssh.nix
    ./modules/home/rbw.nix
    ./modules/home/gpg.nix
    ./modules/home/hyprpaper.nix
    ./modules/home/ai-chat.nix
  ];

  programs = {
    waybar = {
      enable = true;
      systemd.enable = true;
    };
    herdr.enable = true;
    devenv.enable = true;
    home-manager.enable = true;
  };
}
