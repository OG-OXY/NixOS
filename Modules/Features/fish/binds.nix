{
  inputs,
  ...
}:
{  
  flake.nixosModules.fish_user_key_bindings = { pkgs, ... }:
  let
    rustyClip = inputs.rusty-clip.packages.${pkgs.system}.default;
    fishBinds = pkgs.writeText "user-binds.fish" ''
      # This hook runs AFTER Fish finishes its keymap resets, making the bind stick
      function fish_user_key_bindings
          if not functions -q __copy_commandline
              function __copy_commandline
                  #echo "--- BINDING FIRED ---" >> /tmp/fish_debug.log
                  set -l cmd (commandline)
                  #echo "CMD: '$cmd'" >> /tmp/fish_debug.log
                  echo -n "$cmd" | ${rustyClip}/bin/rusty-clip # 2>> /tmp/fish_debug.log
              end
          end
  
          bind -M insert \cy __copy_commandline
          bind \cy __copy_commandline
          
          # --- 2. Snapshot + jjo Full Inline Execution (Ctrl+X) ---
          if not functions -q __exec_jol
              function __exec_jol
                  # Force snapshot via status
                  ${pkgs.jujutsu}/bin/jj status > /dev/null 2>&1

                  ${pkgs.jujutsu}/bin/jj op log --no-graph --template 'if(!description.starts_with("args: jj log"), id.short() ++ "\t" ++ user ++ "\t" ++ time.start().ago() ++ "\t" ++ description ++ "\n")' -n 100 | ${pkgs.fzf}/bin/fzf --delimiter="\t" --with-nth=2.. --preview '${pkgs.jujutsu}/bin/jj diff --git --at-op {1}' --preview-window=right:50%
                  # Full inline jjo op log viewer
                  #${pkgs.jujutsu}/bin/jj op log --no-graph --template 'if(!description.starts_with("snapshot working copy") && !description.starts_with("args: jj log"), id.short() ++ "\t" ++ user ++ "\t" ++ time.start().ago() ++ "\t" ++ description ++ "\n")' -n 100 | ${pkgs.fzf}/bin/fzf --delimiter="\t" --with-nth=2.. --preview '${pkgs.jujutsu}/bin/jj diff --git --at-op {1}' --preview-window=right:65%

                  commandline -f repaint
              end
          end
          bind -M insert \cs __exec_jol
          bind \cs __exec_jol

          if not functions -q __exec_jor_restore
              function __exec_jor_restore
                  ${pkgs.jujutsu}/bin/jj status > /dev/null 2>&1
                  ${pkgs.jujutsu}/bin/jj op log --no-graph --template 'if(!description.starts_with("args: jj log"), id.short() ++ "\t" ++ user ++ "\t" ++ time.start().ago() ++ "\t" ++ description ++ "\n")' -n 100 | ${pkgs.fzf}/bin/fzf --delimiter="\t" --with-nth=2.. --preview '${pkgs.jujutsu}/bin/jj diff --git --at-op {1}' --preview-window=right:50% --bind 'enter:execute(read -p "echo -e \"\nRestore operation {1}? [y/N] \"" -l confirm; if test "$confirm" = "y" -o "$confirm" = "Y"; echo -e "\n[Restoring operation {1}...]"; ${pkgs.jujutsu}/bin/jj op restore {1}; else; echo -e "\n[Aborted restoration for {1}]"; end)+accept'
                  commandline -f repaint
              end
          end
          bind -M insert \cr __exec_jor_restore
          bind \cr __exec_jor_restore
          
          # --- 3. Parent Diff Full Inline Execution (Alt+X) ---
          if not functions -q __exec_jj_diff
              function __exec_jj_diff
                  ${pkgs.jujutsu}/bin/jj diff -r @- | ${pkgs.less}/bin/less -R
                  commandline -f repaint
              end
          end
          bind -M insert \cx __exec_jj_diff
          bind \cx __exec_jj_diff
      end
    '';
  in
  {
    systemd.tmpfiles.rules = [
      "d /home/ty/.config/fish 0755 ty users -"
      "d /home/ty/.config/fish/conf.d 0755 ty users -"
      "L+ /home/ty/.config/fish/conf.d/user-binds.fish 0644 ty users - ${fishBinds}"
    ];
  };
}
