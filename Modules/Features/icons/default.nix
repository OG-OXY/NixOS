{
  ...
}:
{
  flake.nixosModules.icons = { pkgs, ... }: {
    environment.systemPackages = [
      (pkgs.runCommand "combined-icon-theme" {
        buildInputs = [ pkgs.gtk3 ];
      } ''
        mkdir -p $out/share/icons
        # Symlink or copy the base hicolor and your icon themes into the unified output
        ln -s ${pkgs.hicolor-icon-theme}/share/icons/hicolor $out/share/icons/hicolor
        ln -s ${pkgs.papirus-icon-theme}/share/icons/Papirus-Dark $out/share/icons/Papirus-Dark
        # Automatically generate the icon cache inside the derivation so it's clean and pre-built
        #gtk-update-icon-cache -f -t $out/share/icons/hicolor
        #gtk-update-icon-cache -f -t $out/share/icons/Papirus-Dark
      '')
    ];
  };
}
