function add_path --description "Add directory to PATH if the directory exists and not present in PATH variable, appending by default"
    argparse --min-args=1 --exclusive p,a 'p/prepend' 'a/append' -- $argv
    or return 1

    test -n "$_flag_prepend"
    and set flag '--prepend'
    or set flag '--append'

    for p in $argv
        test -d $p
        and set --append paths_to_add $p
    end

    if test (count $paths_to_add) -eq 0
        return 1
    end

    add_unique $flag PATH $paths_to_add

    return 0
end
