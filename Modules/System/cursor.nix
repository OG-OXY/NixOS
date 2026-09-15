{
  pkgs,
  ...
}:
{
  environment.systemPackages = [
    (pkgs.runCommand "custom-cursor" {} ''
      mkdir -p $out/share/icons
      cp -r ${../../Config/Theme/Cursors/Saturn} $out/share/icons/Saturn
    '')
    (pkgs.runCommand "custom-cursor" {} ''
      mkdir -p $out/share/icons
      cp -r ${../../Config/Theme/Cursors/DJ-Fox-C} $out/share/icons/DJ-Fox-C
    '')
    (pkgs.runCommand "custom-cursor" {} ''
      mkdir -p $out/share/icons
      cp -r ${../../Config/Theme/Cursors/Fire-Arrow} $out/share/icons/Fire-Arrow
    '')
  ];
}
