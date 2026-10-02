{
  inputs,
  ...
}:
{
  flake.nixosModules.wlr-which-key = { pkgs, ... }:
  {
    programs.wlr-which-key = {
      enable = true;
      settings = {
        anchor = "center";
        font = "JetBrainsMono NFM 12";
      };
      menus = {
        warp = [
          {
            key = "w";
            desc = "Normal Mode";
            cmd = "${pkgs.warpd}/bin/warpd --normal";
          }
          {
            key = "h";
            desc = "Hint Mode";
            cmd = "${pkgs.warpd}/bin/warpd --hint";
          }
          {
            key = "q";
            desc = "Quadrant Mode";
            cmd = "${pkgs.warpd}/bin/warpd --grid";
          }
        ];
        apps = [
          {
            key = "l";
            desc = "Launcher";
            cmd = "${pkgs.noctalia-shell}/bin/noctalia-shell ipc call launcher toggle";
          }
          {
            key = "h";
            desc = "Herdr";
            cmd = "${pkgs.ghostty}/bin/ghostty -e ${pkgs.herdr}/bin/herdr";
          }
          {
            key = "g";
            desc = "Ghostty";
            cmd = "${pkgs.ghostty}/bin/ghostty";
          }
          {
            key = "y";
            desc = "Yazi";
            cmd = "${pkgs.ghostty}/bin/ghostty -e ${pkgs.fish}/bin/fish -i -C 'y'";
          }
          {
            key = "z";
            desc = "Zen-Browser";
            cmd = "${inputs.zen-browser.packages.${pkgs.system}.default}/bin/zen-beta";
          }
          {
            key = "o";
            desc = "Obsidian";
            cmd = "${pkgs.obsidian}/bin/obsidian /home/ty/Notes/Vault";
          }
          {
            key = "n";
            desc = "Obsidian (New Note)";
            cmd = "xdg-open 'obsidian://new?vault=Vault&name=New%20Note'";
          }
          {
            key = "v";
            desc = "Vesktop";
            cmd = "${pkgs.vesktop}/bin/vesktop";
          }
          {
            key = "s";
            desc = "OBS-Studio";
            cmd = "${pkgs.obs-studio}/bin/obs";
          }
          {
            key = "b";
            desc = "Bitwarden";
            cmd = "${pkgs.bitwarden-desktop}/bin/bitwarden";
          }
          {
            key = "e";
            desc = "EasyEffects";
            cmd = "${pkgs.easyeffects}/bin/easyeffects";
          }
        ];
      };
    };
  };
}
