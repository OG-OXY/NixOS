{
  ...
}:
{
  flake.nixosModules.cursors = { pkgs, ... }:
  {
    environment = {
      variables = {
        XCURSOR_THEME = "Saturn";
        XCURSOR_SIZE = "32";
      };
      sessionVariables = {
        XCURSOR_THEME = "Saturn";
        XCURSOR_SIZE = "32";
      };
      systemPackages = [
        (pkgs.runCommand "saturn-cursor" {} ''
          mkdir -p $out/share/icons
          cp -r ${../../../Config/Theme/Cursors/Saturn} $out/share/icons/Saturn
        '')
        (pkgs.runCommand "dj-fox-c-cursor" {} ''
          mkdir -p $out/share/icons
          cp -r ${../../../Config/Theme/Cursors/DJ-Fox-C} $out/share/icons/DJ-Fox-C
        '')
        (pkgs.runCommand "fire-arrow-cursor" {} ''
          mkdir -p $out/share/icons
          cp -r ${../../../Config/Theme/Cursors/Fire-Arrow} $out/share/icons/Fire-Arrow
        '')
      ];
      pathsToLink = [ "/share/icons" ];
    };
    services.displayManager.noctalia-greeter.settings.cursor = {
      theme = "Saturn";
      size = 32;
    };
  };
}
