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
