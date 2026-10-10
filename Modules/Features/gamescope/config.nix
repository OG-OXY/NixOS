{
 ...
}:
{
  flake.nixosModules.gamescope = { pkgs, ... }:
  let
    dynamicGamescope = pkgs.writeShellScriptBin "gamescope" ''
      CONNECTOR=""
      for d in /sys/class/drm/card*-*; do
        if [ -f "$d/status" ] && [ "$(cat "$d/status")" = "connected" ]; then
          # Match your monitor's model string in the raw EDID sysfs node
          if grep -q "ROG PG258Q" "$d/edid" 2>/dev/null; then
            CONNECTOR=$(basename "$d" | cut -d'-' -f2-)
            break
          fi
        fi
      done
  
      # Fallback if detection fails
      CONNECTOR="''${CONNECTOR:-DP-1}"
  
      # Launch gamescope with the dynamically resolved connector
      exec ${pkgs.gamescope}/bin/gamescope -O "$CONNECTOR" "$@"
    '';
  in
  {
    programs.gamescope = {
      enable = true;
      enableWsi = false;
      package = dynamicGamescope;
    };
  };
}
