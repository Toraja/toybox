function add_path --description "Add directory to PATH if the directory exists and not present in PATH variable, appending by default"
    argparse --min-args=1 --exclusive p,a p/prepend a/append -- $argv
    or return 1

    if test -n "$_flag_prepend"
        set flag --prepend
    else
        set flag --append
    end

    for p in $argv
        if test -d $p
            set --append paths_to_add
        end
    end

    if test (count $paths_to_add) -eq 0
        return 0
    end

    add_unique $flag PATH $paths_to_add

    return 0
end
