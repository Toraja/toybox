function wrap_in_echo_single --description 'echo -n \'$commandline\' | <clipcmd>'
	set --local cmd (commandline)
	commandline --replace ''
	commandline --insert "echo -n '$cmd' | $argv[1]"
end
