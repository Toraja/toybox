function mkfile --description 'Create file as well as containing directory'
    set --local usage 'USAGE:
    '(basename (status --current-filename))' [OPTION] PATH
OPTIONS:
    -h, --help   Display this help
'
    argparse h/help -- $argv
    if test -n "$_flag_help"
        echo 'Create file as well as containing directory'
        echo $usage
        return
    end

    if test (count $argv) -ne 1
        echo $usage
        return 1
    end

    mkdir -p (dirname $argv[1])
    touch $argv[1]
end
