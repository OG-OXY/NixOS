load-env {
    PROMPT_INDICATOR: ''
    PROMPT_INDICATOR_HELIX_INSERT: ':'
    PROMPT_INDICATOR_HELIX_NORMAL: 〉
    PROMPT_MULTILINE_INDICATOR: ':::'
    ATUIN_CONFIG_DIR: (if (whoami) == root {
        '/root/.config/atuin'
    } else {
        $'($env.HOME)/.config/atuin'
    })
    NU_LIB_DIRS: [
        /run/current-system/sw/share/nushell
        /run/current-system/sw/share/nushell/vendor/autoload
        /run/current-system/sw/share/nushell/nu_scripts
        $'($env.HOME)/.nix-profile/share/nushell'
        $'($env.HOME)/.nix-profile/share/nushell/vendor/autoload'
        $'($env.HOME)/.local/share/nushell'
        $'($env.HOME)/.local/share/nushell/vendor/autoload'
        ($nu.default-config-dir | path join /nu)
        ($nu.default-config-dir | path join /nu_scripts)
    ]
}
