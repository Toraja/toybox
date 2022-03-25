function rf --description 'fzf rg result and output file name'
    argparse --min-args=1 'h/hidden' 'o/open' -- $argv
    or return 1

    set query $argv[1]
    set path $argv[2]
    set rg_cmd 'rg --column --line-number --no-heading --color=always --smart-case --glob !.git'
    test -n "$_flag_hidden"; and set rg_cmd "$rg_cmd --hidden"
    set rg_cmd "$rg_cmd -- $query $path"
    set fzf_cmd "fzf --ansi --delimiter : --preview 'bat --style=full --color=always --highlight-line {2} {1}' --preview-window '~3,+{2}+3/2'"

    test -z "$_flag_open"; and begin
        # XXX want to colour the output but grep colours filenames as well ...
        eval "$rg_cmd | $fzf_cmd | grep $query"
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
