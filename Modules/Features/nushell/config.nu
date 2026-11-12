def nsh [] {
    help commands | where command_type == built-in | select name category description | explore
}

$env.PROMPT_INDICATOR = ""
$env.PROMPT_INDICATOR_HELIX_INSERT = ": "
$env.PROMPT_INDICATOR_HELIX_NORMAL = "〉"
$env.PROMPT_MULTILINE_INDICATOR = "::: "

source /home/ty/.config/nushell/vendors/autoload/atuin-nushell-config.nu
