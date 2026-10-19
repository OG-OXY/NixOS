{
  ...
}:
{
  flake.homeModules.nushell = { ... }:
  let
    qwenAgentScript = ./qwenAgent.nu;
  in
  {
    programs = {
      nushell = {
        enable = true;
        envFile.text = ''
          #
        '';
        configFile.text = ''
          $env.config = {
            show_banner: false
            table: {
                mode: rounded
            }
            keybindings: [
                {
                    name: expand_abbr
                    modifier: none
                    keycode: space
                    mode: [emacs, vi_normal, vi_insert]
                    event: {
                        send: executehostcommand
                        cmd: "
                            let line = (commandline)
                            let words = ($line | split row ' ')
                            let last_word = ($words | last)
                            
                            # Check if the last word is in our abbr table
                            if ($last_word in ($abbrs | columns)) {
                                let expanded = ($abbrs | get $last_word)
                                # Replace the last word with the expansion + space
                                commandline edit --replace ($line | str replace --regex $'($last_word)$' $'($expanded) ')
                            } else {
                                # Normal spacebar behavior
                                commandline edit --insert ' '
                            }
                        "
                    }
                }
                {
                    name: expand_abbr_enter
                    modifier: none
                    keycode: enter
                    mode: [emacs, vi_normal, vi_insert]
                    event: {
                        send: executehostcommand
                        cmd: "
                            let line = (commandline)
                            let words = ($line | split row ' ')
                            let last_word = ($words | last)
                          
                            if ($last_word in ($abbrs | columns)) {
                                let expanded = ($abbrs | get $last_word)
                                let new_line = ($line | str replace --regex $'($last_word)$' $expanded)
                                commandline edit --replace $new_line
                            }
                        "
                    }
                }
                {
                    name: send_enter_action
                    modifier: none
                    keycode: enter
                    mode: [emacs, vi_normal, vi_insert]
                    event: { send: enter }
                }
              
            ]
          }
          def nsh [] {
              help commands | where command_type == built-in | select name category description | explore
          }
          alias qwen-agent = nu ${qwenAgentScript}
          alias hl = hx
          alias nrs = nh os switch .
          alias nrsu = nh os switch . --upgrade
          alias jbs = jj bookmark set master -r @
          alias jgp = jj git push --all --allow-empty-description
          let abbrs = {
              "jdc": 'jj describe commit "',
          }
        '';
      };
      carapace = {
        enable = true;
        enableNushellIntegration = true;
      };
      starship.enableNushellIntegration = true;
      atuin.enableNushellIntegration = true;
      direnv = {
        enable = true;
        enableNushellIntegration = true;
        enableFishIntegration = true;
      };
    };
  };
  flake.nixosModules.nushell = { ... }:
  {
    programs.nushell = {
      enable = true;
    };
  };
}
