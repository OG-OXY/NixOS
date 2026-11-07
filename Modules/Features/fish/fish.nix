{
  ...
}:
{
  flake.homeModules.fish = { pkgs, lib, ... }:
  let
    makeOrg = builtins.readFile ./.fish/makeorg.fish;
  in
  {
    programs.fish = {
      enable = true;
      functions = {
        jor = { 
          description = "Fuzzy select a past operation to RESTORE working copy state";
          body = ''
            jj status > /dev/null 2>&1
            jj op log --no-graph --template 'if(!description.starts_with("args: jj log"), id.short() ++ "\t" ++ user ++ "\t" ++ time.start().ago() ++ "\t" ++ description ++ "\n")' -n 100 | fzf --delimiter="\t" --with-nth=2.. --preview 'jj diff --git --at-op {1}' --preview-window=right:50% --bind 'enter:execute(read -p "echo -e \"\nRestore operation {1}? [y/N] \"" -l confirm; if test "$confirm" = "y" -o "$confirm" = "Y"; echo -e "\n[Restoring operation {1}...]"; jj op restore {1}; else; echo -e "\n[Aborted restoration for {1}]"; end)+accept'
          '';
        };
        jol = {
          description = "Browse jj operation log history with live diff preview";
          body = ''
            jj status > /dev/null 2>&1
            jj op log --no-graph --template 'if(!description.starts_with("args: jj log"), id.short() ++ "\t" ++ user ++ "\t" ++ time.start().ago() ++ "\t" ++ description ++ "\n")' -n 100 | fzf --delimiter="\t" --with-nth=2.. --preview 'jj diff --git --at-op {1}' --preview-window=right:50%
          '';
        };
        gemmy = {
          description = "Gemini-Flash API_KEY Rotation Script (unlimited gemmy flash!)";
          body = ''
            set -l keys "$GEMINI_KEY_1" "GEMINI_KEY_2" "GEMINI_KEY_3"
            set -l key_count (count $keys)
            if test $key_count -eq 0 -o "$keys[1]" = ""
                echo "Error: Gemini keys not found in session environment!"
           rn 1
            end
    
            set -l selected_key $keys[(math 1 + (random) % $key_count)]

            echo "=== Launching OpenCode with Gemini Flash, Rotating Keys! ==="
            env GEMINI_API_KEY=$selected_key opencode $argv
          '';
        };
        logout = {
          description = "Logout of Niri UWSM Session to Greeter";
          body = ''
            # Option 1: Quit Niri directly (recommended for UWSM)
            if type -q niri
                niri msg action quit; and uwsm stop -s
            else
                uwsm stop -s
            end
          '';
        };
        makeorg = {
          description = "Convert all files in PWD from Markdown to Org";
          body = ''
            ${makeOrg}
          '';
        };
      };

      shellAliases = {
      };

      shellAbbrs = {
        hl = "hx";
        dt = "emacsclient --socket-name=doom -t";
        et = "emacsclient --socket-name=emacs -t";
        ds = "systemctl --user restart doom";        
        es = "systemctl --user restart emacs";
        dc = "emacsclient --socket-name=doom -c -a 'doom'";
        ec = "emacsclient --socket-name=emacs -c -a 'emacs'";
        steamrun = "gamescope --backend wayland -W 1920 -H 1080 -r 240 -f -e -- steam -gamepadui";
        su = "sudo -i";
        ls = "ls -a";
        cds = "cd ~/NixOS/Master";
        cdn = "cd ~/Notes";
        cdc = "cd ~/.config";
        cdl = "cd ~/.local";
        cdsh= "cd ~/.local/share";
        cdb = "cd ~/.local/bin";
        cdst = "cd ~/.local/state";
        cdsx = "cd ~/.local/share/steel";
        jl = "jj log";
        jla = "jj l";
        jdr = "jj diff -r @-";
        jd = "jj d";
        jc = "jj commit -m \"";
        jmc = "jj new @ origin@master";
        jbs = "jj bookmark set master -r @";
        jdc = "jj describe -m \"";
        jgp = "jj git push --all --allow-empty-description";
        yy = "doas yazi";
        nrs = "nh os switch .";
        nrsu = "nh os switch . --update";
        nrt = "nh os test .";
        nrtu = "nh os test . --update";
        nrvm = "nh os vm-build .";
        vm = "./result/bin/run-nixos-vm";
        nrb = "nh os build .";
        nb = "nix-backup";
        nub = "nix-upgrade-backup";
        nck = "doas nh clean all --keep 5";
        nc = "doas nh clean all";
        dfb = "df -h /boot";
        dfr = "df -h /";
        ts = "doas tailscale up";
        pcig = "lspci | grep \'|\'";
        btcs = "doas bluetoothctl connect 21:35:F7:94:2E:26";
        btcbb = "doas bluetoothctl connect D6:88:C3:AC:1B:0C";
      };

      shellInit = ''
        set -g fish_color_command ffaa22 # your preferred fiery orange/yellow
        set -g fish_color_param 2255ff  # your preferred deep blue
        
        # High-contrast custom palette for the rest
        set -g fish_color_normal ffaa22 #e0e0e0           # Clean bright foreground
        set -g fish_color_quote ff6655            # Fiery red-orange for strings
        set -g fish_color_redirection 00e5ff      # Bright Niri cyan for IO redirects
        set -g fish_color_end ff79c6              # Hot pink/magenta for end separators
        set -g fish_color_error ff4433            # Bright red for errors
        set -g fish_color_comment 555555          # Deep gray for comments
        set -g fish_color_match --background=2255ff # Deep blue background for matched text
        set -g fish_color_selection white --bold --background=555555
        set -g fish_color_search_match bryellow --background=555555
        set -g fish_color_operator cc33ff         # Magenta for operators
        set -g fish_color_escape ffcc44           # Bright orange-yellow for escapes
        set -g fish_color_autosuggestion 555555   # Subtle dark gray for autosuggestions
        set -g fish_color_cwd 55ff77              # Vibrant green for working directory
        set -g fish_color_cwd_root ff4433         # Warning red for root cwd
        set -g fish_color_user brgreen            # Bright green for user
        set -g fish_color_host normal             # Default for host
        set -g fish_color_status ff4433           # Red status indicator
        set -g fish_color_valid_path --underline  # Underlined valid paths
        
        # Pager menus
        set -g fish_pager_color_prefix white --bold
        set -g fish_pager_color_completion normal
        set -g fish_pager_color_description ffcc44 --dim
        set -g fish_pager_color_progress brwhite --background=00e5ff
      '';

      interactiveShellInit = ''
        set -g fish_handle_reflow 1
        set -U fish_ambiguous_width 1
        set -U fish_emoji_width 1
        # set -g fish_key_bindings fish_helix_key_bindings
        set -gx STARSHIP_SHELL "fish"
        set -g fish_greeting "Welcome to NixOS!"

        function __devenv_auto_greeting --on-event fish_prompt
            if set -q SHOW_PROJECT_GREETING
                set -e SHOW_PROJECT_GREETING
                
                switch "$PWD"
                    case "*/Develop/C*"
                        echo "⚡ C/C++ Development Environment Active"
                        gcc --version | head -n 1
                        cmake --version | head -n 1
                    case "*/Develop/Rust*"
                        echo "🦀 Rust Development Environment Active"
                        rustc --version
                    case "*/Develop/Web*"
                        echo "🌐 Web Development Environment Active"
                        node --version
                    case "*/Develop/QMK*"
                        echo "  QMK Firmware Environment Active"
                        qmk --version
                    case '*'
                        echo "❄  Devenv Environment Active"
                end
            end
        end

        if test "$USER" = "root"
            ${pkgs.fastfetch}/bin/fastfetch 2>/dev/null
            set -gx ATUIN_CONFIG_DIR "/root/.config/atuin"
        else
            set -gx ATUIN_CONFIG_DIR "$HOME/.config/atuin"
            ${pkgs.fastfetch}/bin/fastfetch
        end
        # Not Needed with Home-manager direnv integrations
        # Also pretty sure this effects devenv to because devenv uses direnv behind the scenes
        # if type -q direnv
        #     ${lib.getExe pkgs.direnv} hook fish | source
        # end
        if type -q devenv
            ${lib.getExe pkgs.devenv} hook fish | source
        end
        # Not Needed with home manager integrations
        # ${pkgs.starship}/bin/starship init fish | source
        # ${pkgs.zoxide}/bin/zoxide init fish --cmd cd | source
        # Not how this works. look into atuin-fish-config.fish
        # ${pkgs.atuin}/bin/atuin init fish | source
      '';

      plugins =
      let
        fish = pkgs.fishPlugins;
        mkPlugin = pkg: {
          name = pkg.pname or pkg.name;
          src = pkg.src or pkg;
        };
      in
      (map mkPlugin [
        fish.bass
        fish.fzf-fish
        fish.autopair
        fish.sponge
        fish.done
      ])
      ++ [
        {
          name = "abbreviation-tips";
          src = pkgs.fetchFromGitHub {
            owner = "gazorby";
            repo = "fish-abbreviation-tips";
            rev = "v0.7.0";
            sha256 = "sha256-F1t81VliD+v6WEWqj1c1ehFBXzqLyumx5vV46s/FZRU=";
          };
        }
        {
          name = "fish-you-should-use";
          src = pkgs.fetchFromGitHub {
            owner = "paysonwallach";
            repo = "fish-you-should-use";
            rev = "master";
            sha256 = "sha256-MmGDFTgxEFgHdX95OjH3jKsVG1hdwo6bRht+Lvvqe5Y=";
          };
        }
        {
          name = "fish-helix";
          src = pkgs.fetchFromGitHub {
            owner = "sshilovsky";
            repo = "fish-helix";
            rev = "main";
            sha256 = "sha256-JqN4IbLpJFBJKNE6haZH2iFSMrLFdVh+Hbl840+xbfU=";
          };
        }
      ];
    };
  };
}
