{
  pkgs,
  ...
}:
let
  fishBinding = pkgs.writeText "copy-buffer.fish" ''
    # This hook runs AFTER Fish finishes its keymap resets, making the bind stick
    function fish_user_key_bindings
        if not functions -q __copy_commandline
            function __copy_commandline
                #echo "--- BINDING FIRED ---" >> /tmp/fish_debug.log
                set -l cmd (commandline)
                #echo "CMD: '$cmd'" >> /tmp/fish_debug.log
                echo -n "$cmd" | ${pkgs.wl-clipboard}/bin/wl-copy# 2>> /tmp/fish_debug.log
            end
        end

        bind -M insert \ey __copy_commandline
        bind \ey __copy_commandline
    end
  '';
in
{
  systemd.tmpfiles.rules = [
    "d /home/ty/.config/fish 0755 ty users -"
    "d /home/ty/.config/fish/conf.d 0755 ty users -"
    "C /home/ty/.config/fish/conf.d/copy-buffer.fish 0644 ty users - ${fishBinding}"
  ];
}
