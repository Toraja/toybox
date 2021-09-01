function fish_prompt --description 'Write out the prompt'
    # fish status
    set status_color (test $status -eq 0; and echo cyan; or echo red)
    set prompt (colorise $status_color fish)

    # USER SHLVL CWD
    set --append prompt :(colorise green $USER):(colorise yellow $SHLVL):(colorise green (prompt_pwd))

    # git status
    git rev-parse --is-inside-work-tree >/dev/null 2>&1; and begin
        set git_status (git status --porcelain)
        set git_color (test (count $git_status) -eq 0; and echo cyan; or echo magenta)
        set branch (git branch | grep '*' | awk '{print $2}')
        test -z $branch; and set branch '(none)'
        set git ' ['(colorise $git_color $branch)']'
        set --append prompt $git
    end

    # symbol
    set symbol '$'
    if test $USER = 'root'
        set symbol '#'
    end
    set --append prompt \n$symbol' '

    string join '' $prompt
end

function colorise
    argparse --name=colorise --min-args=2 'h/help' -- $argv
    echo (set_color $argv[1])$argv[2..-1](set_color normal)
end
