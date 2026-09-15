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
        tmux.tmux-sessionx
        tmux.sensible
        tmux.vim-tmux-navigator
        tmux.resurrect
        tmux.continuum
      ];

    extraConfig = ''
      # 1. True Color Support
      set -g default-terminal "tmux-256color"
      set -ag terminal-overrides ",xterm-256color:RGB"
      set -g allow-passthrough on
      set -g exit-empty off
      set -g destroy-unattached off

      # 2. Continuum & Resurrect settings
      set -g @continuum-restore 'on'
      set -g @continuum-save-interval '15'

      # 3. Logical Split Keybindings (using current path)
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      unbind '"'
      unbind %

      # 4. Seamless Vim-style Pane Navigation (Prefix + h, j, k, l)
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      # 5. Vim-style Pane Resizing (Prefix + Shift + h/j/k/l, repeatable)
      bind -r H resize-pane -L 5
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r L resize-pane -R 5

      # 6. Wayland Clipboard Integration for Copy Mode
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "${pkgs.wl-clipboard}/bin/wl-copy"

      # 7. Force clear pane border colors so active/inactive states are obvious
      set -g pane-border-style fg=colour238
      set -g pane-active-border-style fg=colour208 # Or pick a high-contrast accent (like Gruvbox orange/yellow)

      # 8. Automatically redraw/fix partial line rendering artifacts on focus change
      set -g focus-events on
    '';
  };
}
