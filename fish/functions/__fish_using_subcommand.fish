function __fish_using_subcommand
    set -l maincmd $argv[1]
    set -l subcmd $argv[2]
    set cmdline (commandline -opc)
    if [ (count $cmdline) -lt 3 ]
        return 1
    end
    contains -- $maincmd $cmdline; and contains -- $subcmd $cmdline
end
