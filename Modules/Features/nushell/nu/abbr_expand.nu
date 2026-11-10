export def --env abbr_expand []: any -> string {
    let line = (commandline)
    let words = ($line | split row ' ')
    let last_word = ($words | last)

    if ($last_word in ($abbrs | columns)) {
        let expanded = ($abbrs | get $last_word)
        let new_line = ($line | str replace --regex $'($last_word)$' $expanded)
        commandline edit --replace $new_line
    } else {
        commandline edit --insert ' '
    }
}
