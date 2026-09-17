{
  pkgs,
  lib,
  ...
}:
let
  herdrConfig = pkgs.writeText "herdr-config.toml" ''
    [keys]
    prefix = "ctrl+space"
  '';
in
{
  environment.systemPackages = [
    pkgs.herdr
    (pkgs.runCommand "herdr-completions" {} ''
      mkdir -p $out/share/fish/vendor_completions.d
      ${lib.getExe pkgs.herdr} completions fish > $out/share/fish/vendor_completions.d/herdr.fish
    '')
  ];

  # Superior tmpfiles approach
  systemd.tmpfiles.rules = [
    "d /home/ty/.config/herdr 0755 ty users -"
    "C /home/ty/.config/herdr/config.toml - - - - ${herdrConfig}"
  ];
}
