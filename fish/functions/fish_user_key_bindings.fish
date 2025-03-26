function fish_user_key_bindings
    bind \cx\cr reload_keybind

    # motion
    bind \cf forward-single-char
    bind \e\cf forward-bigword
    bind \e\cb backward-bigword
    bind \c] forward-jump
    bind \e\c] backward-jump
    bind \e\; repeat-jump
    bind \e, repeat-jump-reverse

    # traverse
    bind \eU '.. && commandline -f repaint'

    # edit
    bind \eh backward-kill-word
    bind \e\cw backward-kill-bigword
    bind \e\cd kill-bigword
    bind \e\cu kill-whole-line
    bind \el downcase-word
    bind --key nul 'commandline --insert " " && commandline -f backward-char'

    # search
    bind \ep history-prefix-search-backward
    bind \en history-prefix-search-forward
    bind \e\cp history-token-search-backward
    bind \e\cn history-token-search-forward

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
    bind \cg suppress-autosuggestion
    bind \e\? __fish_man_page
    bind \e\ci complete-and-search
    bind \cx\cp __fish_paginate
    bind \cx\ch "commandline_smart_append '--help &| less'"
    bind \cx\cl __fish_list_current_token
    bind \cx\ca "commandline_append_and_cursor_end '| xargs -r '"
    bind \cx\cf "commandline_append_and_cursor_end '| fzf '"
    bind \cx\ck 'commandline_append_and_cursor_end "| awk \'{print \$1}\' "'
    bind \cx\co "commandline --insert (git rev-parse --show-toplevel)/"

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
        bind \cq 'commandline_smart_append \'| $clipper\''
        bind \eq 'wrap_in_echo_single \'$clipper\''
        bind \e\cq 'wrap_in_echo_double \'$clipper\''
    end

    function bind_wrapper
        argparse --name=wrap_job --min-args=3 --max-args=3 h/help -- $argv
        set key $argv[1] # should not escape or backslash will be duplicated
        set start (string escape --no-quoted $argv[2])
        set end (string escape --no-quoted $argv[3])

        bind \e$key't' "wrap_token $start $end"
        bind \e$key'p' "wrap_process $start $end"
        bind \e$key'j' "wrap_job $start $end"
        bind \e$key'a' "wrap_to_beginning $start $end"
        bind \e$key'e' "wrap_to_end $start $end"
    end

    bind_wrapper \( \( \)
    bind_wrapper \) \( \)
    bind_wrapper \{ \{ \}
    bind_wrapper \} \{ \}
    bind_wrapper \" \" \"
    bind_wrapper \' \' \'

    # selection
    bind --sets-mode selection \cx\x20 begin-selection
    bind --mode selection \cx\cx swap-selection-start-stop repaint
    bind --mode selection --sets-mode default \cx\x20 end-selection repaint
    bind --mode selection --sets-mode default \e end-selection repaint
    bind --mode selection --sets-mode default \cw kill-selection end-selection repaint
    bind --mode selection --sets-mode default \ek kill-selection end-selection repaint
    bind --mode selection \cp up-line
    bind --mode selection \cn down-line
    bind --mode selection \cf forward-char
    bind --mode selection \cb backward-char
    bind --mode selection \ef forward-word
    bind --mode selection \eb backward-word
    bind --mode selection \e\cf forward-bigword
    bind --mode selection \e\cb backward-bigword
    bind --mode selection \ca beginning-of-line
    bind --mode selection \ce end-of-line
    bind --mode selection \x1D forward-jump
    # Ctrl-Alt-] does not work, and \x1D does not work with ALT key
    bind --mode selection \e] backward-jump
    bind --mode selection \e\; repeat-jump
    bind --mode selection \e, repeat-jump-reverse

    # fzf
    if functions --query fzf_key_bindings
        bind \co fzf-file-widget
        bind \eo fzf-cd-widget
    end
end
