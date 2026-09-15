#ghostty.nix
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
      adjust-cell-height = "-10%";
      adjust-cell-width = "-10%";
      cursor-style = "block";
      grapheme-width-method = "legacy";
      shell-integration-features = "no-cursor";
      scrollback-limit = 100000000;
      font-family = "JetBrainsMono NFM Bold";
      font-family-bold = "JetBrainsMono NFM ExtraBold";
      font-family-italic = "JetBrainsMono NFM Bold Italic";
      font-family-bold-italic = "JetBrainsMono NFM ExtraBold Italic";
      font-size = 22;
      font-feature = [
        "liga"
        "calt"
      ];
    };
  };
}
