{
  pkgs,
  lib,
  ...
}:
{
  environment.systemPackages = [
    (pkgs.runCommand "herdr-completions" {} ''
      mkdir -p $out/share/fish/vendor_completions.d
      ${lib.getExe pkgs.herdr} completions fish > $out/share/fish/vendor_completions.d/herdr.fish
    '')
    (pkgs.runCommand "saturn-cursor" {} ''
      mkdir -p $out/share/icons
      cp -r ${../../Config/Theme/Cursors/Saturn} $out/share/icons/Saturn
    '')
    (pkgs.runCommand "dj-fox-c-cursor" {} ''
      mkdir -p $out/share/icons
      cp -r ${../../Config/Theme/Cursors/DJ-Fox-C} $out/share/icons/DJ-Fox-C
    '')
    (pkgs.runCommand "fire-arrow-cursor" {} ''
      mkdir -p $out/share/icons
      cp -r ${../../Config/Theme/Cursors/Fire-Arrow} $out/share/icons/Fire-Arrow
    '')
  ];
}
