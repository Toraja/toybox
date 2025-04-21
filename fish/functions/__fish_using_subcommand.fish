function __fish_using_subcommand
    set --local maincmd $argv[1]
    set --local subcmd $argv[2]
    set cmdline (commandline --cut-at-cursor --current-process --tokens-expanded)
    if [ (count $cmdline) -lt 3 ]
        return 1
    end
    contains -- $maincmd $cmdline; and contains -- $subcmd $cmdline
end
