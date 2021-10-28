function set_display --description='Wrapper for setting DISPLAY'
    is_display_set; and return;

    # If docker desktop uses WSL as backend, IP address in /etc/resolv.conf does
    # not work. Use docker instead.
    is_inside_docker || is_docker_desktop; and begin
        wsl_docker
        return
    end

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

function is_display_set --description='Check if DISPLAY is set'
    return (test -n "$DISPLAY")
end

function wsl_docker --description='DISPLAY for docker container'
    set --export --global DISPLAY host.docker.internal:0.0
end

function is_inside_docker --description='Check if it is inside docker container'
    return (test -f "/.dockerenv")
end

function is_docker_desktop --description='Check if docker desktop uses WSL as backedn'
    return (grep -q -i host.docker.internal /etc/hosts)
end
