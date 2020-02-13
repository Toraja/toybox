function wrap_to_beginning --description 'Wrap text from cursor the beginning of line'
    argparse --name=wrap_token --min-args=2 --max-args=2 'h/help' -- $argv
    set col (commandline --cursor)
    set cmd (commandline)
    set first_half (string sub --length $col $cmd)
    set last_half (string sub --start (math $col + 1) $cmd)
    commandline --replace "$argv[1]$first_half$argv[2]$last_half"
    commandline --cursor (math $col + (string length (string join '' $argv)))
end
