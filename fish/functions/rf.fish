function rf --description 'fzf rg result and output file name'
    set --local usage \
        "
USAGE:
    "(basename (status current-function))" [OPTION] QUERY [PATH]
OPTIONS:
    -o, --open   Open selected files in nvim
    -H, --hidden Include hidden files
"

    argparse --min-args=1 H/hidden o/open -- $argv
    or begin
        echo $usage
        return 1
    end

    set query "$argv[1]"
    set path $argv[2]
    set rg_cmd 'rg --column --line-number --no-heading --color=always --smart-case --glob !.git'
    if test -n "$_flag_hidden"
        set rg_cmd "$rg_cmd --hidden"
    end
    set rg_cmd "$rg_cmd -- '$query' $path"
    set fzf_cmd "fzf --ansi --delimiter : --preview 'bat --style=full --color=always --highlight-line {2} {1}' --preview-window '~3,+{2}+3/2'"

    if test -z "$_flag_open"
        # XXX want to colour the output but grep colours filenames as well ...
        eval "$rg_cmd | $fzf_cmd | grep '$query'"
        return
    end

    set errordir /tmp/nvimerrorfile
    set errorfile $errordir/error.err
    mkdir -p $errordir
    touch $errorfile
    eval "$rg_cmd | $fzf_cmd > $errorfile"
    if test $status -ne 0
        return
    end
    nvim -q $errorfile -c copen
end
