function set_display --description='Wrapper for setting DISPLAY'
    is_display_set; and return

    # If docker desktop uses WSL as backend, IP address in /etc/resolv.conf does
    # not work. Use docker instead.
    is_inside_docker || is_docker_desktop; and begin
        docker_display
        return
    end
end

function is_display_set --description='Check if DISPLAY is set'
    return (test -n "$DISPLAY")
end

function docker_display --description='DISPLAY for docker container'
    set --export --global DISPLAY host.docker.internal:0.0
end

function is_inside_docker --description='Check if it is inside docker container'
    return (test -f "/.dockerenv")
end

function is_docker_desktop --description='Check if docker desktop uses WSL as backend'
    return (grep --quiet --ignore-case host.docker.internal /etc/hosts && docker ps &>/dev/null)
end
