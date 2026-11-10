$env.config = {
    edit_mode: helix
    show_banner: false
    table: {
        mode: rounded
    }
    keybindings: [
        {
            name: expand_abbr
            modifier: none
            keycode: space
            mode: [ emacs vi_normal vi_insert helix_normal helix_insert helix_select ]
            event: {
                send: executehostcommand
                cmd: "
                    let line = (commandline)
                    let words = ($line | split row ' ')
                    let last_word = ($words | last)
                    
                    if ($last_word in ($abbrs | columns)) {
                        let expanded = ($abbrs | get $last_word)
                        commandline edit --replace ($line | str replace --regex $'($last_word)$' $'($expanded) ')
                    } else {
                        commandline edit --insert ' '
                    }
                "   
            }
        }
        {
            name: execute_abbr
            modifier: none
            keycode: enter
            mode: [ emacs vi_normal vi_insert helix_normal helix_insert helix_select ]
            event: {
                send: executehostcommand
                cmd: "
                    let line = (commandline)
                    let words = ($line | split row ' ')
                    let last_word = ($words | last)

                    if ($last_word in ($abbrs | columns)) {
                        let expanded = ($abbrs | get $last_word)
                        let new_line = ($line | str replace --regex $'($last_word)$' $expanded)
                        commandline edit --replace ''
                        nu -c $new_line
                    } else {
                        # If not an abbr, clear prompt and run the typed line normally
                        commandline edit --replace ''
                        nu -c $line
                    }
                "
            }
        }
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

# Nushell Alias Example
# alias hl = hx

let abbrs = {
    hl: hx,
    su: 'sudo -i',
    yy: 'doas yazi',
    ls: 'ls -a',
    dfr: 'df -h /', # Storage Analysis on /
    dfb: 'df -h /boot', # Storage Analysis on /boot
    dfrv: 'df -h | grep /', # Verbose Storage Analysis on /
    dfbv: 'df -h | grep /boot', # Verbose Storage Analysis on /boot
    dfmv: 'df -h | grep /mnt', # Verbose Storage Analysis on /
    cds: 'cd ~/NixOS/Master',
    cdn: 'cd ~/Notes',
    cdc: 'cd ~/.config',
    cdl: 'cd ~/.local',
    cdsh: 'cd ~/.local/share',
    cdb: 'cd ~/.local/bin',
    cdst: 'cd ~/.local/state',
    cdsx: 'cd ~/.local/share/steel',
    jd: 'jj d',
    jdr: 'jj diff -r @-',
    jl: 'jj log',
    jla: 'jj l',
    jc: 'jj commit -m "',
    jmc: 'jj new @ origin@master',
    jbs: 'jj bookmark set master -r @',
    jdc: 'jj describe -m "',
    jgp: 'jj git push --all --allow-empty-description',
    nrs: 'nh os switch .',
    nrsu: 'nh os switch . --update',
    nrt: 'nh os test .',
    nrtu: 'nh os test . --update',
    nrvm: 'nh os vm-build .',
    vm: ./result/bin/run-nixos-vm,
    nrb: 'nh os build .',
    nc: 'doas nh clean all',
    nck: 'doas nh clean all --keep 5',
    nb: nix-backup,
    nub: nix-upgrade-backup,
    ds: 'systemctl --user restart doom',
    es: 'systemctl --user restart emacs',
    dt: 'emacsclient --socket-name=doom -t',
    et: 'emacsclient --socket-name=emacs -t',
    dc: 'emacsclient --socket-name=doom -c -a "doom"',
    ec: 'emacsclient --socket-name=emacs -c -a "emacs"',
    ts: 'doas tailscale up',
    btc: 'doas bluetoothctl connect 21:35:F7:94:2E:26',
    pcig: 'lspci | grep | "'
}

def nsh []: any -> table {
    help commands | where command_type == built-in | select name category description | explore
}

# def abbr_expand []: any -> string {
#     let line = (commandline)
#     let words = ($line | split row ' ')
#     let last_word = ($words | last)

#     if ($last_word in ($abbrs | columns)) {
#         let expanded = ($abbrs | get $last_word)
#         let new_line = ($line | str replace --regex $'($last_word)$' $expanded)
#         commandline edit --replace ''
#         nu -c $new_line
#     } else {
#         # If not an abbr, clear prompt and run the typed line normally
#         let normal_line = $line
#         commandline edit --replace ''
#         nu -c $normal_line
#     }
# }

# def abbr-exec []: any -> string {
#     let line = (commandline)
#     let words = ($line | split row ' ')
#     let last_word = ($words | last)

#     if ($last_word in ($abbrs | columns)) {
#         let expanded = ($abbrs | get $last_word)
#         let new_line = ($line | str replace --regex $'($last_word)$' $expanded)
#         commandline edit --replace ''
#         nu -c $new_line
#     } else {
#         # If not an abbr, clear prompt and run the typed line normally
#         let normal_line = $line
#         commandline edit --replace ''
#         nu -c $normal_line
#     }
# }

# Abbr
# "steamrun": 'gamescope --backend wayland -W 1920 -H 1080 -r 240 -f -e -- steam -gamepadui',
# let line = (commandline)
# let words = ($line | split row ' ')
# let last_word = ($words | last)

# if ($last_word in ($abbrs | columns)) {
#     let expanded = ($abbrs | get $last_word)
#     commandline edit --replace ($line | str replace --regex $'($last_word)$' $'($expanded) ')
# } else {
#     commandline edit --insert ' '
# }
