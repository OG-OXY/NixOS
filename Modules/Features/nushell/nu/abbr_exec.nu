export def --env abbr_exec []: any -> string {
    let line = (commandline)
    let words = ($line | split row ' ')
    let last_word = ($words | last)

    if ($last_word has ($abbrs | columns)) {
        let expanded = ($abbrs | get --optional $last_word)
        let new_line = ($line | str replace --regex $'($last_word)$' $expanded)
        commandline edit --replace ''
        $new_line
    } else {
        # If not an abbr, clear prompt and run the typed line normally
        let normal_line = $line
        commandline edit --replace ''
        $normal_line
    }
}
