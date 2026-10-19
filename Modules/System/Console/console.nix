{
  ...
}:
{
  flake.nixosModules.console = { ... }:
  {
    console = {
      colors = [
        "121212" # 0: Black (Deep Charcoal background)
        "ff4433" # 1: Red (Fiery orange-red)
        "33cc55" # 2: Green (Vibrant terminal green)
        "ffaa22" # 3: Yellow (Warm orange-yellow)
        "2255ff" # 4: Blue (Deep electric blue from fastfetch)
        "cc33ff" # 5: Magenta (Hot pink/magenta)
        "00e5ff" # 6: Cyan (Bright Niri/Yazi cyan accent)
        "e0e0e0" # 7: White (Clean bright foreground)
        # Bright variants (8-15)
        "555555" # 8: Bright Black
        "ff6655" # 9: Bright Red
        "55ff77" # 10: Bright Green
        "ffcc44" # 11: Bright Yellow
        "4477ff" # 12: Bright Blue (Deep blue highlight)
        "ff55ff" # 13: Bright Magenta
        "55ffff" # 14: Bright Cyan
        "ffffff" # 15: Bright White
      ];
    };
  };
}
