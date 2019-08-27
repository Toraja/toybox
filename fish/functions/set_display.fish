function set_display
    set ip (grep nameserver /etc/resolv.conf | awk '{print $2}')
    set -xg DISPLAY $ip:0.0
end
