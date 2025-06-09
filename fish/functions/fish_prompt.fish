function fish_prompt --description 'Write out the prompt'
    set --local prompt

    # fish status
    set status_color (test $status -eq 0; and echo cyan; or echo red)
    set --append prompt (colorise $status_color fish)

    # SHLVL USER HOSTNAME CWD
    # hostname must be function because HOSTNAME variable is not necessarily defined
    set --append prompt [(colorise yellow $SHLVL)]:(colorise green $USER)@(colorise yellow (hostname)):(colorise green (prompt_pwd))

    # git status
    if git rev-parse --is-inside-work-tree >/dev/null 2>&1
        set git_status (git status --porcelain)
        set git_color (test (count $git_status) -eq 0; and echo cyan; or echo magenta)
        set branch (git branch --show-current)
        test -z $branch; and set branch '(none)'
        set git ' ['(colorise $git_color $branch)']'
        set --append prompt $git
    end

    # whether tmux is still running
    if not set --query TMUX && tmux has-session 2>/dev/null
        set --append prompt ' ['(colorise green tmux)']'
    end

    # symbol
    set symbol '$'
    if test $USER = root
        set symbol '#'
    end

    string join '' $prompt
    echo "$symbol "
end

function colorise
    argparse --name=colorise --min-args=2 h/help -- $argv
    echo (set_color $argv[1])$argv[2..-1](set_color normal)
end
