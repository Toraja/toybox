function wrap_to_end --description 'Wrap text from cursor the end of line'
    argparse --name=wrap_token --min-args=2 --max-args=2 'h/help' -- $argv
    set col (commandline --cursor)
    commandline --insert $argv[1]
    commandline --append $argv[2]
    commandline --cursor $col
end
