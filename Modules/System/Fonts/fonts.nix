{
  ...
}:
{
  flake.nixosModules.fonts = { pkgs, ... }:
  {
    fonts = {
      packages = [
        pkgs.nerd-fonts.jetbrains-mono
        pkgs.nerd-fonts.fira-code
        pkgs.font-awesome
        pkgs.inter
      ];
      fontconfig = {
        enable = true;
        defaultFonts = {
          emoji = [
            "JetBrainsMono Nerd Font"
          ];
          monospace = [
            "JetBrainsMono Nerd Font"
            "FiraCode Nerd Font"
          ];
          sansSerif = [
            "Inter"
            "Font Awesome 6 Free"
            "Font Awesome 6 Brands"
          ];
          serif = [
            "Inter"
            "Font Awesome 6 Free"
            "Font Awesome 6 Brands"
          ];
        };
        localConf = ''
          <?xml version="1.0"?>
          <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
          <fontconfig>
            <selectfont>
              <rejectfont>
                <pattern>
                  <patelt name="family">
                    <string>Noto Color Emoji</string>
                  </patelt>
                </pattern>
              </rejectfont>
            </selectfont>
          </fontconfig> 
        '';
      };
    };
  };
}
