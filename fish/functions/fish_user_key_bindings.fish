function fish_user_key_bindings
    bind ctrl-x,ctrl-r reload_keybind

    # motion
    bind ctrl-f forward-single-char
    bind ctrl-alt-f forward-bigword
    bind ctrl-alt-b backward-bigword
    bind ctrl-\] forward-jump
    bind ctrl-alt-\] backward-jump
    bind alt-\; repeat-jump
    bind alt-comma repeat-jump-reverse

    # traverse
    bind alt-U '.. && commandline --function repaint'

    # edit
    bind ctrl-alt-h backward-kill-word
    bind ctrl-alt-w backward-kill-bigword
    bind ctrl-alt-d kill-bigword
    bind ctrl-alt-u kill-whole-line
    bind alt-l downcase-word
    bind ctrl-space 'commandline --insert " " && commandline --function backward-char'

    # search
    bind alt-p history-prefix-search-backward
    bind alt-n history-prefix-search-forward
    bind ctrl-alt-p history-token-search-backward
    bind ctrl-alt-n history-token-search-forward

    function commandline_smart_append
        if not commandline | string length -q
            commandline --replace $history[1]
        end

        if [ (string split '' (commandline))[-1] != ' ' ]
            commandline --append ' '
        end

        fish_commandline_append $argv[1]
    end

    function commandline_append_and_cursor_end
        commandline_smart_append $argv[1]
        commandline --function end-of-line
    end

    # misc
    bind ctrl-c cancel-commandline
    bind ctrl-g suppress-autosuggestion
    bind alt-\? __fish_man_page
    bind alt-tab complete-and-search
    bind ctrl-x,ctrl-p __fish_paginate
    bind ctrl-x,ctrl-h "commandline_smart_append '--help &| less'"
    bind ctrl-x,ctrl-l __fish_list_current_token
    bind ctrl-x,ctrl-a "commandline_append_and_cursor_end '| xargs -r '"
    bind ctrl-x,ctrl-f "commandline_append_and_cursor_end '| fzf '"
    bind ctrl-x,ctrl-k 'commandline_append_and_cursor_end "| awk \'{print \$1}\' "'
    bind ctrl-x,ctrl-o "commandline --insert (git rev-parse --show-toplevel)/"

    # wrapper
    # clipbin is exported to use inside tmux.conf
    if type --quiet clip.exe
        set --global --export clipbin 'clip.exe'
    else if type -q xsel
        set --global --export clipbin xsel -i --clipboard
    else if type -q xclip
        set --global --export clipbin xclip -selection c
    end
    if set --query TMUX
        set --global clipper clip_to_tmux
        # Below does not work (`and` command not found), so keep using the function above
        # set -g clipper tmux load-buffer -\; and tmux save-buffer - \| $clipbin
    else if set --query clipbin
        set --global clipper $clipbin
    end

    if set --query clipper
        bind ctrl-q 'commandline_smart_append \'| $clipper\''
        bind alt-q 'wrap_in_echo_single \'$clipper\''
        bind ctrl-alt-q 'wrap_in_echo_double \'$clipper\''
    end

    function bind_wrapper
        argparse --name=wrap_job --min-args=3 --max-args=3 h/help -- $argv
        set key $argv[1] # should not escape or backslash will be duplicated
        set start (string escape --no-quoted $argv[2])
        set end (string escape --no-quoted $argv[3])

        bind alt-$key,t "wrap_token $start $end"
        bind alt-$key,p "wrap_process $start $end"
        bind alt-$key,j "wrap_job $start $end"
        bind alt-$key,a "wrap_to_beginning $start $end"
        bind alt-$key,e "wrap_to_end $start $end"
    end

    bind_wrapper \( \( \)
    bind_wrapper \) \( \)
    bind_wrapper \{ \{ \}
    bind_wrapper \} \{ \}
    bind_wrapper \" \" \"
    bind_wrapper \' \' \'

    # selection
    bind --sets-mode selection ctrl-x,ctrl-space begin-selection
    bind --mode selection ctrl-x,ctrl-x swap-selection-start-stop repaint
    bind --mode selection --sets-mode default ctrl-x,ctrl-space end-selection repaint
    bind --mode selection --sets-mode default escape end-selection repaint
    bind --mode selection --sets-mode default ctrl-w kill-selection end-selection repaint
    bind --mode selection --sets-mode default alt-k kill-selection end-selection repaint
    bind --mode selection ctrl-p up-line
    bind --mode selection ctrl-n down-line
    bind --mode selection ctrl-f forward-char
    bind --mode selection ctrl-b backward-char
    bind --mode selection alt-f forward-word
    bind --mode selection alt-b backward-word
    bind --mode selection ctrl-alt-f forward-bigword
    bind --mode selection ctrl-alt-b backward-bigword
    bind --mode selection ctrl-a beginning-of-line
    bind --mode selection ctrl-e end-of-line
    bind --mode selection ctrl-\] forward-jump
    bind --mode selection ctrl-alt-\] backward-jump
    bind --mode selection alt-\; repeat-jump
    bind --mode selection alt-comma repeat-jump-reverse

    # XXX: inside neovim terminal, ctrl-alt keybind emits different keycodes,
    # so additional keybinds are needed.
    # But these keybinds do not work.
    bind alt-\x06 forward-bigword
    bind alt-\x02 backward-bigword
    bind alt-\x1d backward-jump
    bind alt-\x08 backward-kill-word
    bind alt-\x17 backward-kill-bigword
    bind alt-\x04 kill-bigword
    bind alt-\x15 kill-whole-line
    bind alt-\x10 history-token-search-backward
    bind alt-\x0e history-token-search-forward
    bind ctrl-alt-i complete-and-search
    bind alt-\x11 'wrap_in_echo_double \'$clipper\''
    bind --mode selection alt-\x06 forward-bigword
    bind --mode selection alt-\x02 backward-bigword
    bind --mode selection alt-\x1d backward-jump
end
