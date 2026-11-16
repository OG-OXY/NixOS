if (whoami) == root {
    fastfetch e>/dev/null
} else {
    fastfetch
}

def nsh []: nothing -> nothing {
    help commands | where command_type == built-in | select name category description | explore
}
