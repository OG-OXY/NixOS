#atuin.nix
{
  ...
}:
{
  programs.atuin = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      ai.enabled = true;
      dialect = "us";
      timezone = "local";
      auto_sync = true;
      show_preview = true;
      exit_mode = "return-original";
      keymap_cursor = {
        emacs = "blink-block";
        vim_normal = "steady-block";
      };
      keymap_mode = "vim-insert";
      word_jump_mode = "subl";
      word_chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
      show_numeric_shortcuts = true;
      show_help = true;
      show_tabs = true;
      enter_accept = true;
      command_chaining = true;
      sync.records = true;
      tmux.enabled = false;
    };
  };
}
