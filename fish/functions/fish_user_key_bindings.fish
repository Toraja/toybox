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
    if set --query TMUX
        # Modern terminals is able to get text from tmux buffer and put it to clipboard
        set --global --export clipbin tmux load-buffer -w -
    else if type --quiet xsel
        set --global --export clipbin xsel --input --clipboard
    else if type --quiet xclip
        set --global --export clipbin xclip -selection c
    end

    if set --query clipbin
        bind ctrl-q 'commandline_smart_append \'| $clipbin\''
        bind alt-q 'wrap_in_echo_single \'$clipbin\''
        bind ctrl-alt-q 'wrap_in_echo_double \'$clipbin\''
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

    # Inside neovim terminal, ctrl-alt keybind emits different keycodes,
    # so additional keybinds are needed.
    bind \e\[6\;3u forward-bigword # ctrl-alt-f
    bind \e\[2\;3u backward-bigword # ctrl-alt-b
    bind \e\[29\;3u backward-jump # ctrl-alt-]
    bind \e\[8\;3u backward-kill-word # ctrl-alt-h
    bind \e\[23\;3u backward-kill-bigword # ctrl-alt-w
    bind \e\[4\;3u kill-bigword # ctrl-alt-d
    bind \e\[21\;3u kill-whole-line # ctrl-alt-u
    bind \e\[16\;3u history-token-search-backward # ctrl-alt-p
    bind \e\[14\;3u history-token-search-forward # ctrl-alt-n
    bind ctrl-alt-i complete-and-search
    bind \e\[17\;3u 'wrap_in_echo_double \'$clipbin\'' # ctrl-alt-q
    bind --mode selection alt-\x06 forward-bigword
    bind --mode selection alt-\x02 backward-bigword
    bind --mode selection alt-\x1d backward-jump
end
