function add_unique --description "Add values to list if not contained, appending by default"
    argparse --name=add_unique --min-args=2 -x p,a 'p/prepend' 'a/append' -- $argv
    or return 1

    set listname $argv[1]
    set list (eval echo '$'$listname)
    set values $argv[2..-1]

    for v in $values
        not contains $v $list
        and set -a new_values $v
    end

    test -n "$_flag_prepend"
    and set -gp $listname $new_values
    or set -ga $listname $new_values
end
