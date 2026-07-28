{
  ...
}:
{
  programs.ghostty = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      theme = "Aurora";
      background-opacity = 1.0;
      cursor-style = "block";
      shell-integration-features = "no-cursor";
      font-family = "JetBrainsMono Nerd Font Bold";
      font-family-bold = "JetBrainsMono Nerd Font ExtraBold";
      font-family-italic = "JetBrainsMono Nerd Font Bold Italic";
      font-family-bold-italic = "JetBrainsMono Nerd Font ExtraBold Italic";
      font-size = 22;
      font-feature = [
        "liga"
        "calt"
      ];
    };
  };
}
