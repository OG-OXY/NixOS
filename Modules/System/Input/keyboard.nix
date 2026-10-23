{
  ...
}:
{
  flake.nixosModules.keyboard = { ... }:
  {
    boot.kernelParams = [
      "kbd.repeat_delay=285"
      "kbd.repeat_rate=45"
    ];
    # --- System-wide XKB & Console Keyboard ---
    services.xserver.xkb = {
      layout = "us";
      variant = ""; # Standard US layout
    };
    environment.sessionVariables.XKB_DEFAULT_LAYOUT = "us";
  };
}
