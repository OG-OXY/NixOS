#fish.nix
{ pkgs, ... }: {
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
      #j = {
      #  description = "tell jj to grab secrets from secretspec.";
      #  body = ''
      #    secretspec run -- jj $argv
      #  '';
      #};
      #gh = {
      #  description = "tell github-cli to grab secrets from secretspec";
      #  body = ''
      #    secretspec run -- gh $argv
      #  '';
      #};
      ss = {
        description = "For Grabbing secrets.";
        body = ''
          secretspec run -- $argv
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
      #jj = {
      #  description = "Jujutsu";
      #  body = ''
      #    command jj $argv
      #  '';
      #};
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
      jd = "jj diff";
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
      nrs = "sudo nixos-rebuild switch --flake .#nixos";
      nrsu = "sudo nixos-rebuild switch --upgrade --flake .#nixos";
      nrt = "sudo nixos-rebuild test --flake .#nixos";
      nrtu = "sudo nixos-rebuild test --upgrade --flake .#nixos";
      nrvm = "sudo nixos-rebuild build-vm --flake .#nixos";
      vm = "./result/bin/run-nixos-vm";
      nhs = "nh os switch .";
      nhsu = "nh os switch . --upgrade";
      nb = "nix-backup";
      nub = "nix-upgrade-backup";
      nhc = "sudo nh clean all --keep 5";
      dfb = "df -h /boot";
      dfr = "df -h /";
      ts = "doas tailscale up";
      pcig = "lspci | grep \'|\'";
      btc = "bluetoothctl connect D6:88:C3:AC:1B:0C";
      tm = "tmux";
      tma = "tmux attach";
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
      set -U fish_emoji_width 2
      fish_vi_key_bindings

      if test "$USER" = "root"
          fastfetch 2>/dev/null
        else
          fastfetch
      end
      starship init fish | source
      if test "$USER" = "root"
        set -gx ATUIN_CONFIG_DIR "/root/.config/atuin"
          else
        set -gx ATUIN_CONFIG_DIR "$HOME/.config/atuin"
      end
      if type -q direnv
          direnv hook fish | source
      end
      zoxide init fish | source
      atuin init fish | source
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
}
