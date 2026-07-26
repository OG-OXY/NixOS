{
  pkgs,
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
    };
  };

  xdg = {
    configFile = {
      "ghostty/config".text = ''
        theme = GruvBoxDark
        background-opacity = 1.0
      '';
      "secretspec/config.toml".text = ''
        [defaults]
        provider = "keyring"
        profile = "default"
      '';
      "secretspec/secretspec.toml".text = ''
        [project]
        name = "global-dev"
        version = "1.0"
        [secrets]
        GITHUB_TOKEN = { description = "GitHub Access Token" }
      '';
    };
    dataFile = {
      #
    };
  };
  imports = [
    ./modules/home/ghostty.nix
    ./modules/home/tmux.nix
    ./modules/home/fish.nix
    ./modules/home/atuin.nix
    ./modules/home/yazi.nix
    ./modules/home/git.nix
    ./modules/home/github-cli.nix
    ./modules/home/jujutsu.nix
    ./modules/home/ssh.nix
    ./modules/home/rbw.nix
    ./modules/home/gpg.nix
  ];

  systemd.user = {
    sessionVariables = {
      PINENTRY_USER_DATA = "gtk";
    };
  };

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
