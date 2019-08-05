function wrap_token --description 'Wrap token under cursor on command line'
	argparse --name=wrap_token --min-args=2 --max-args=2 'h/help' -- $argv
	set cmd (commandline --current-token)
	commandline --current-token --replace "$argv[1]$cmd$argv[2]"
end

