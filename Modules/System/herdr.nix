{
  pkgs,
  lib,
  ...
}:
let
  herdrConfig = pkgs.writeText "herdr-config.toml" ''
    onboarding = false
    

    [theme]
    name = "terminal"

    [ui]
    status_indicators = "symbols"

    [ui.sound]
    enabled = true
    
    [ui.toast]
    delivery = "herdr"

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
    #should probably use C+ instead ("+" means force so that even if theres a file already there it still writed to config)
    "L+ /home/ty/.config/herdr/config.toml 0644 ty users - ${herdrConfig}"
  ];
}
