function wrap_in_echo_double --description 'echo -n "$commandline" | <copycmd>'
	set -l cmd (commandline)
	commandline -r ''
	commandline -i "echo -n \"$cmd\" | $copycmd"
end
