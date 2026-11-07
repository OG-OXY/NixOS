{
  ...
}:
{
  flake.nixosModules.systemdUserLinksModule = { lib, config, ... }:
  let
    users = [
      { name = "ty"; home = "/home/ty"; group = "users"; }
      { name = "root"; home = "/root"; group = "root"; }
    ];
    # List of specs: [ { path = ".config/helix/config.toml"; source = helixConfig; type = "L+"; } ]
    mkLinks = entries:
      let
        expandEntry = u: entry:
          let
            fullPath = "${u.home}/${entry.path}";
            # Automatically parse the parent directory from the target path!
            dirPath = dirOf fullPath;
            ruleType = entry.type or "L+"; # Defaults to symlink (L+), can be overridden to (C+)
          in [
            "d ${dirPath} 0755 ${u.name} ${u.group} -"
            "${ruleType} ${fullPath} - - - - ${entry.source}"
          ];
      in
      lib.unique (lib.flatten (map (u: map (e: expandEntry u e) entries) users));
  in
  {
    # Option 1: Expose mkLinks globally via specialArgs or a custom module attribute
    # Option 2: Provide it directly to any module that imports this or uses config.lib
    config.systemd.tmpfiles.rules = mkLinks (config.systemd.userLinks or []);

    # Define a custom option so any module can cleanly declare its links
    options.systemd.userLinks = lib.mkOption {
      type = lib.types.listOf (lib.types.submodule {
        options = {
          path = lib.mkOption { type = lib.types.str; };
          source = lib.mkOption { type = lib.types.path; };
          type = lib.mkOption { type = lib.types.enum [ "L+" "C+" ]; default = "L+"; };
        };
      });
      default = [];
    };
  };
}
