$env.config = {
    edit_mode: helix
    buffer_editor: hx
    show_banner: false
    table: {
        mode: rounded
    }
    keybindings: [
        {
            name: atuin_search
            modifier: none
            keycode: up
            mode: [ emacs vi_normal vi_insert helix_normal helix_insert ]
            event: {
                send: executehostcommand
                cmd: "atuin search --interactive"
            }
        }
    ]
}

def nsh [] {
    help commands | where command_type == built-in | select name category description | explore
}
