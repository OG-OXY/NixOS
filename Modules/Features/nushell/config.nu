def nsh [] {
    help commands | where command_type == built-in | select name category description | explore
}
