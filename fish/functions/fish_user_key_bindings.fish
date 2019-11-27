function fish_user_key_bindings
    bind \cx\cr reload_keybind

    # motion
    bind \e\cf forward-bigword
    bind \e\cb backward-bigword
    bind \x1D forward-jump
    bind \e\x1D backward-jump
    bind \e\; repeat-jump
    bind \e, repeat-jump-reverse

    # edit
    bind \eh backward-kill-word
    bind \e\cw backward-kill-bigword
    bind \e\cd kill-bigword
    bind \e\cu kill-whole-line
    bind \el downcase-word

    # search
    bind \ep history-token-search-backward
    bind \en history-token-search-forward

    # misc
    bind \cg suppress-autosuggestion
    bind \e\? __fish_man_page
    bind \e\ci complete-and-search
    bind \cx\cp __fish_paginate
    bind \cx\cl __fish_list_current_token
    bind \cx\ca "commandline -a \" | xargs \"; commandline -f end-of-line"

    # wrapper
    if type -q xsel
        set -g clipbin xsel -i --clipboard
    else if type -q xclip
        set -g clipbin xclip -selection c
    end
    if set -q TMUX
        set -g copycmd 'clip_tmux_buffer'
    else if type -q clip.exe
        set -g copycmd 'clip.exe'
    else if string match -qr xterm $TERM; and set -q clipbin
        set -g copycmd $clipbin
    end

    if set -q copycmd
        bind \cq "commandline -a \" | $copycmd\""
        bind \eq wrap_in_echo_single
        bind \e\cq wrap_in_echo_double
    end

    function bind_wrapper
        argparse --name=wrap_job --min-args=3 --max-args=3 'h/help' -- $argv
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
    bind -m selection \cx\x20 begin-selection
    bind -M selection -m default \cx\cx swap-selection-start-stop repaint
    bind -M selection -m default \cx\x20 end-selection repaint
    bind -M selection -m default \e end-selection repaint
    bind -M selection -m default \cw kill-selection end-selection repaint
    bind -M selection -m default \ek kill-selection end-selection repaint
    bind -M selection \cp up-line
    bind -M selection \cn down-line
    bind -M selection \cf forward-char
    bind -M selection \cb backward-char
    bind -M selection \ef forward-word
    bind -M selection \eb backward-word
    bind -M selection \e\cf forward-bigword
    bind -M selection \e\cb backward-bigword
    bind -M selection \ca beginning-of-line
    bind -M selection \ce end-of-line
    bind -M selection \x1D forward-jump
    bind -M selection \e\x1D backward-jump
    bind -M selection \e\; repeat-jump
    bind -M selection \e, repeat-jump-reverse
end
