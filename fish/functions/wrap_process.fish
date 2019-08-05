function wrap_process --description 'Wrap process under cursor on command line'
	argparse --name=wrap_process --min-args=2 --max-args=2 'h/help' -- $argv
	set cmd (commandline --current-process)
	commandline --current-process --replace "$argv[1]$cmd$argv[2]"
end
