{
  ...
}:
{
  flake.nixosModules.yazi = { ... }:
  {
    programs.yazi = {
      enable = true;
      enableFishIntegration = true;
      #settings = {
      #  yazi = {
      #    manager = {
      #      show_hidden = true;
      #      sort_by = "mtime";
      #      sort_sensitive = false;
      #      sort_reverse = true;
      #    };
      #    #"[[plugin.prepend_fetchers]]" = {
      #    #  url = "*";
      #    #  run = "git";
      #    #  group = "git";
      #    #};
      #  };
      #  #theme = {
      #  #  git = {
      #  #    unstaged = { fg = "blue"; };
      #  #    deleted  = { fg = "red"; bold = true; };
      #  #    unknown_sign = " ";
      #  #    unstaged_sign = "-S";
      #  #    staged_sign = "S";
      #  #    deleted_sign = "-D";
      #  #    clean_sign = "✔";
      #  #    ignored_sign = "I";
      #  #    untracked_sign = "-T";
      #  #    added_sign = "+S";
      #  #    updated_sign = "U";
      #  #  };
      #  #};
      #  #keymap = {
      #  #  "[[mgr.prepend_keymap]]" = {
      #  #    on = [ "c" "h" ];
      #  #    run = "plugin chmod";
      #  #    desc = "Chmod selected files";
      #  #  };
      #  #};
      #};
    };
  };
}
