{
  ...
}:
{
  flake.homeModules.ghostty = { ... }:
  {
    programs.ghostty = {
      enable = true;
      enableFishIntegration = true;
      settings = {
        confirm-close-surface = false;
        #theme = "Aurora";
        background-opacity = 1.0;
        adjust-cell-height = "-10%";
        adjust-cell-width = "-10%";
        cursor-style = "block";
        grapheme-width-method = "legacy";
        shell-integration-features = "no-cursor";
        scrollback-limit = 100000000;
        # Turns off color emojis?
        font-codepoint-map = "U+1F000-U+1F9FF = JetBrainsMono NFM ExtraBold";
        font-family = "JetBrainsMono NFM ExtraBold";
        font-family-bold = "JetBrainsMono NFM ExtraBold";
        font-family-italic = "JetBrainsMono NFM ExtraBold Italic";
        font-family-bold-italic = "JetBrainsMono NFM ExtraBold Italic";
        font-size = 25;
        font-feature = [
          "liga"
          "calt"
          "-colr"
          "-cpal"
        ];
        background = "161616";
        foreground = "fadb14";
        cursor-color = "f06449";
        cursor-text = "161616";
        selection-background = "00d8b6";
        selection-foreground = "161616";

        window-padding-x = 0;
        window-padding-y = 0;
        window-decoration = false;

        palette = [
          "0=#161616"
          "1=#f06449"
          "2=#00c853"
          "3=#fadb14"
          "4=#2551fe"
          "5=#f02e6b"
          "6=#00d8b6"
          "7=#f06449"
          "8=#45475a"
          "9=#f06449"
          "10=#00e676"
          "11=#fadb14"
          "12=#2551fe"
          "13=#f02e6b"
          "14=#00d8b6"
          "15=#f06449"
        ];
      };
    };
  };
}
