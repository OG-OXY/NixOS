# rog.fish
set -l rog_connector ""
for d in /sys/class/drm/card*-*
    if test -f "$d/status" -a (cat "$d/status") = connected
        if grep -q "ROG PG258Q" "$d/edid" 2>/dev/null
            set rog_connector (basename "$d" | string replace -r 'card.-' '')
            break
        end
    end
end
echo "$rog_connector"
niri msg output $rog_connector mode 1920x1080@240
