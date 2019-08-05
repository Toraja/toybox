function wrap_job --description 'Wrap job under cursor on command'
	argparse --name=wrap_job --min-args=2 --max-args=2 'h/help' -- $argv
	set cmd (commandline --current-job)
	commandline --current-job --replace "$argv[1]$cmd$argv[2]"
end
