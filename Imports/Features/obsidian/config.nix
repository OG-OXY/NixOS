{
  ...
}:
{
  flake.nixosModules.obsidian = { pkgs, ... }:
  {
    environment.systemPackages = [
      (pkgs.obsidian.overrideAttrs (old: {
        postInstall = (old.postInstall or "") + ''
          wrapProgram $out/bin/obsidian \
            --add-flags "--ozone-platform-hint=auto --enable-features=UseOzonePlatform --force-dark-mode"
        '';
      }))
    ];
  };
}
