$env.NU_LIB_DIRS = [
    # /run/current-system/sw/share/nushell
    # /run/current-system/sw/share/nushell/vendor
    # /run/current-system/sw/share/nushell/vendor/autoload
    /run/current-system/sw/share/nushell/nu_scripts
    # ~/.nix-profile/share/nushell
    # ~/.nix-profile/share/nushell/vendor
    # ~/.nix-profile/share/nushell/vendor/autoload
    # ~/.local/share/nushell
    # ~/.local/share/nushell/vendor
    # ~/.local/share/nushell/vendor/autoload
    ($nu.default-config-dir | path join /nu)
    ($nu.default-config-dir | path join nu_scripts)
    ($nu.default-config-dir | path join /run/current-system/sw/share/nushell/nu_scripts)
]
