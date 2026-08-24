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
      j = {
        description = "tell jj to grab secrets from secretspec.";
        body = ''
          secretspec run -- jj $argv
        '';
      };
      gh = {
        description = "tell github-cli to grab secrets from secretspec";
        body = ''
          secretspec run -- gh $argv
        '';
      };
      ss = {
        description = "For Grabbing secrets.";
        body = ''
          secretspec run -- $argv
        '';
      };
      steamrun = {
        description = "Start GameScope with optimized settings with full steamdeck experience";
        #body = ''
        #  env __NV_PRIME_RENDER_OFFLOAD=1 \
        #     __GLX_VENDOR_LIBRARY_NAME=nvidia \
        #      ENABLE_GAMESCOPE_WSI=1 \
        #      gamescope --backend wayland --adaptive-sync -w 1920 -h 1080 -W 2560 -H 1440 -r 236 -f -e -- steam -gamepadui $argv
        #'';
        body = ''
          gamescope --backend wayland -W 1920 -H 1080 -r 240 -f -e -- steam -gamepadui $argv
        '';
      };
      pci = {
        description = "Ls and Grep PCI ID's";
        body = ''
          lspci | grep $argv
        '';
      };
    };

    shellAbbrs = {
      su = "doas fish";
      ls = "ls -a";
      cds = "cd ~/NixOS/nixos";
      ga = "git add -A";
      gc = "git commit -m \"\"";
      gp = "git push -u origin master";
      gpf = "git push -u --force origin master";
      jbs = "jj bookmark set master -r @";
      jdc = "jj describe -m \"\"";
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
      nb = "nix-backup";
      nub = "nix-upgrade-backup";
      ts = "doas tailscale up";
      pcig = "lspci | grep \'|\'";
    };

    interactiveShellInit = ''
      set -g fish_greeting "Welcome to NixOS!"
      set -g fish_handle_reflow 1

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
