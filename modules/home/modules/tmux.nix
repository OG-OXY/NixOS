{
  pkgs,
  ...
}:
{
  programs.tmux = {
    enable = true;
    clock24 = true;
    baseIndex = 1;
    escapeTime = 10;
    keyMode = "vi";
    shortcut = "b";
    shell = "${pkgs.fish}/bin/fish";

    plugins = 
      let 
        tmux = pkgs.tmuxPlugins;
        mkPlugin = pkg: {
          plugin = pkg;
        };
      in
      map mkPlugin [
        tmux.sensible
        tmux.vim-tmux-navigator
        tmux.resurrect
        tmux.continuum
      ];

    extraConfig = ''
      set -g allow-passthrough on
      set -g default-terminal "tmux-256color"
      set -ag terminal-overrides ",xterm-256color:RGB"
      set -g @continuum-restore 'on'
      set -g @continuum-save-interval '15'
    '';
  };
}
