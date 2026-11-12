{
  inputs,
  ...
}:
{
  flake.homeModules.nushell = { pkgs, config, ... }:
  let
    nushellConfig = ./config.nu;
    nushellEnv = ./env.nu;
    nushellNu = ./nu;
    # nushellNuScripts = "${inputs.nuscripts}";
  in
  {
    programs.nushell = {
      enable = true;
      settings = {
        show_banner = "false";
        edit_mode = "helix";
        buffer_editor = "hx";
        table = {
          mode = "rounded";
        };
        keybindings = [
          {
            name = "atuin_search";
            modifier = "none";
            keycode = "up";
            mode = [ "helix_normal" "helix_insert" ];
            event = {
              send = "executehostcommand";
              cmd = "atuin search --interactive";
            };
          }
        ];
        abbreviations = {
          hl = "hx";
          su = "sudo -i";
          yy = "doas yazi";
          ls = "ls -a";
          dfr = "df -h /"; # Storage Analysis on /;
          dfb = "df -h /boot"; # Storage Analysis on /boot;
          dfrv = "df -h | grep /"; # Verbose Storage Analysis on /;
          dfbv = "df -h | grep /boot"; # Verbose Storage Analysis on /boot;
          dfmv = "df -h | grep /mnt"; # Verbose Storage Analysis on /;
          cds = "cd ~/NixOS/Master";
          cdn = "cd ~/Notes";
          cdc = "cd ~/.config";
          cdl = "cd ~/.local";
          cdsh = "cd ~/.local/share";
          cdb = "cd ~/.local/bin";
          cdst = "cd ~/.local/state";
          cdsx = "cd ~/.local/share/steel";
          jd = "jj d";
          jdr = "jj diff -r @-";
          jl = "jj log";
          jla = "jj l";
          jc = "jj commit -m '";
          jmc = "jj new @ origin@master";
          jbs = "jj bookmark set master -r @";
          jdc = "jj describe -m '";
          jgp = "jj git push --all --allow-empty-description";
          nrs = "nh os switch .";
          nrsu = "nh os switch . --update";
          nrt = "nh os test .";
          nrtu = "nh os test . --update";
          nrvm = "nh os vm-build .";
          vm = "./result/bin/run-nixos-vm";
          nrb = "nh os build .";
          nc = "doas nh clean all";
          nck = "doas nh clean all --keep 5";
          nb = "nix-backup";
          nub = "nix-upgrade-backup";
          ds = "systemctl --user restart doom";
          es = "systemctl --user restart emacs";
          dt = "emacsclient --socket-name=doom -t";
          et = "emacsclient --socket-name=emacs -t";
          dc = "emacsclient --socket-name=doom -c -a 'doom'";
          ec = "emacsclient --socket-name=emacs -c -a 'emacs'";
          ts = "doas tailscale up";
          btc = "doas bluetoothctl connect 2135F7942E26";
          pcig = "lspci | grep | '";
        };
      };
      envFile.source = nushellEnv;
      configFile.source = nushellConfig;
      plugins =
      let
        nu = pkgs.nushellPlugins;
      in
      [
        nu.formats
        nu.polars
        nu.query
        # nu.highlight
      ];
    };
    home.file = {
      ".config/nushell/nu".source = config.lib.file.mkOutOfStoreSymlink "${nushellNu}";
      # ".config/nushell/nu_scripts".source = config.lib.file.mkOutOfStoreSymlink "${inputs.nuscripts}";
      # ".config/nushell/vendors/autoload".source = config.lib.file.mkOutOfStoreSymlink "/run/current-system/sw/share/nushell/vendor/autoload";
    };
  };
  flake.nixosModules.nushell = { ... }:
  {
    programs.nushell.enable = true;
  };
}
