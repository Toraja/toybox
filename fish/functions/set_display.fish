function set_display --description='Wrapper for setting DISPLAY'
    # grep --quiet --ignore-case microsoft /proc/version; and begin
    # grep on alpine linux does not support long options
    grep -q -i microsoft /proc/version; and begin
        wsl_display
        return
    end
end

function wsl_display --description='DISPLAY for WSL'
    set ip (grep nameserver /etc/resolv.conf | awk '{print $2}')
    set --export --global DISPLAY $ip:0.0
end
