function add_unique --description "Add values to list if not contained, appending by default"
    argparse --name=add_unique --min-args=2 -x p,a 'p/prepend' 'a/append' -- $argv
    or return 1

    test -n "$_flag_prepend"
    and set flag '--prepend'
    or set flag '--append'

    set listname $argv[1]
    set values $argv[2..-1]

    for v in $values
        not contains $v (string split ' ' (eval echo '$'$listname))
        and set -g $flag $listname $v
    end

    return 0
end
