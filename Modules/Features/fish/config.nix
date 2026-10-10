{
  ...
}:
{
  flake.homeModules.fish = { pkgs, lib, ... }:
  {
    programs.fish = {
      enable = true;
      functions = {
        gback = {
          description = "Safely undo the last Git commit but keep file changes.";
          body = ''
            if not git rev-parse --is-inside-work-tree >/dev/null 2>&1
                echo (set_color red)"❌ Error: Not a git repository!"(set_color normal)
                return 1
            end
                echo (set_color yellow)"⏪ Undoing last commit safely (keeping modifications)..."(set_color normal)       git reset --soft HEAD~1
                echo (set_color green)"✨ Done! Check 'git status' to see your uncommitted files."(set_color normal)
          '';
        };
        pci = {
          description = "Ls and Grep PCI ID's";
          body = ''
            lspci | grep $argv
          '';
        };
        sysclean = {
          description = "Clear Nix Generations and Boot";
          body = ''
            sudo nix-env --delete-generations +5 --profile /nix/var/nix/profiles/system
            sudo nh clean all --keep 5
          '';
        };
        wl-copy = {
          description = "Rusty-Clip!";
          body = ''
            rusty-clip $argv
          '';
        };
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
        jss = {
          description = "";
          body = ''
            jj workspace snapshot
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
      };

      shellAbbrs = {
        steamrun = "gamescope --backend wayland -W 1920 -H 1080 -r 240 -f -e -- steam -gamepadui";
        su = "doas fish";
        ls = "ls -a";
        cds = "cd ~/NixOS/nixos";
        ga = "git add -A";
        gc = "git commit -m \"\"";
        gp = "git push -u origin master";
        gpf = "git push -u --force origin master";
        jl = "jj log";
        jla = "jj l";
        jdr = "jj diff -r @- | less -R";
        jd = "jj d | less -R";
        jbs = "jj bookmark set master -r @";
        jdc = "jj describe -m \"";
        jc = "jj commit -m \"";
        jmc = "jj new @ origin@master";
        jgp = "jj git push --all --allow-empty-description";
        yz = "yazi";
        nv = "nvf";
        snv = "sudoedit nvf";
        v = "vis";
        sv = "sudoedit vis";
        sy = "doas yazi";
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
        btcsw = "doas bluetoothctl connect 54:D4:96:53:E4:41";
        btcs = "doas bluetoothctl connect D6:88:C3:AC:1B:0C";
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
        set -g fish_greeting "Welcome to NixOS!"
        set -g fish_handle_reflow 1
        set -U fish_ambiguous_width 1
        set -U fish_emoji_width 1

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
        if type -q direnv
            ${lib.getExe pkgs.direnv} hook fish | source
        end
        if type -q devenv
            ${lib.getExe pkgs.devenv} hook fish | source
        end
        ${pkgs.starship}/bin/starship init fish | source
        ${pkgs.zoxide}/bin/zoxide init fish | source
        ${pkgs.atuin}/bin/atuin init fish | source
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
        ];
    };
  };
}
