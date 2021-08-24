#!/bin/bash

dist_wsl='wsl'

is_wsl() {
	grep -q -i microsoft /proc/version && return 0 || return 1
}

get_dist() {
	is_wsl && echo ${dist_wsl} && return
}

is_docker_running() {
	docker ps &>/dev/null && return 0 || return 1
}

start_docker_init_script() {
	sudo service docker start
}

main() {
	is_docker_running
	[[ $? -eq 0 ]] && return 0

	cyan=$(tput setaf 6)
	nc=$(tput sgr 0)
	echo ${cyan}Starting Docker...${nc}

	case $(get_dist) in
		${dist_wsl})
			start_docker_init_script
			;;
		*)
			echo "Unsupported distribution"
			exit 1
	esac
}

main

