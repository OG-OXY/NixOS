$env.NU_LIB_DIRS = [
    /run/current-system/sw/share/nushell
    /run/current-system/sw/share/nushell/vendor/autoload
    ~/.nix-profile/share/nushell
    ~/.nix-profile/share/nushell/vendor/autoload
    ~/.local/share/nushell
    ~/.local/share/nushell/vendor/autoload
    ($nu.default-config-dir | path join scripts)
]
