{
  pkgs,
  ...
}:
{
  environment.systemPackages = [
    (pkgs.runCommand "fish-custom-bindings" {} ''
      mkdir -p $out/share/fish/vendor_conf.d
      echo "bind \\c@y 'commandline | wl-copy'" > $out/share/fish/vendor_conf.d/copy-buffer.fish
    '')
  ];
}
