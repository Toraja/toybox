function wrap_in_echo_double --description 'echo -n "$commandline" | <clipcmd>'
	set -l cmd (commandline)
	commandline -r ''
	commandline -i "echo -n \"$cmd\" | $argv[1]"
end
