function fish_user_key_bindings
    bind \cx\cr reload_keybind

    # motion
    bind \e\cf forward-bigword
    bind \e\cb backward-bigword
    bind \x1D forward-jump
    bind \e\x1D backward-jump

    # edit
    bind \eh backward-kill-word
    bind \e\cw backward-kill-bigword
    bind \e\cd kill-bigword
    bind \e\cu kill-whole-line

    # search
    bind \ep history-token-search-backward
    bind \en history-token-search-forward

    # misc
    bind \e\? __fish_man_page
    bind \e\ci complete-and-search
    bind \e\\ __fish_paginate

    # wrapper
    if set -q TMUX
        set -g copycmd 'tmux load-buffer -'
    else if test -f /mnt/c/Windows/System32/clip.exe
        set -g copycmd 'clip.exe'
    else if string match -qr xterm $TERM
        set -g copycmd 'xclip -selection c'
    end

    if set -q copycmd
        bind \cq "commandline -a \" | $copycmd\""
        bind \eq wrap_in_echo_single
        bind \e\cq wrap_in_echo_double
    end

    bind \e\)t 'wrap_token \( \)'
    bind \e\)p 'wrap_process \( \)'
    bind \e\)j 'wrap_job \( \)'
    bind \e\}t 'wrap_token \{ \}'
    bind \e\}p 'wrap_process \{ \}'
    bind \e\}j 'wrap_job \{ \}'
    bind \e\"t 'wrap_token \" \"'
    bind \e\"p 'wrap_process \" \"'
    bind \e\"j 'wrap_job \" \"'
    bind \e\'t "wrap_token \' \'"
    bind \e\'p "wrap_process \' \'"
    bind \e\'j "wrap_job \' \'"

    # selection
    bind -M selection \cf forward-char
    bind -M selection \cb backward-char
    bind -M selection \ef forward-word
    bind -M selection \eb backward-word
    bind -M selection \e\cf forward-bigword 
    bind -M selection \e\cb backward-bigword
    bind -M selection \ca beginning-of-line
    bind -M selection \ce end-of-line
    bind -m selection \cx\x20 begin-selection
    bind -M selection -m default \cx\cx swap-selection-start-stop repaint
    bind -M selection -m default \cx\x20 end-selection repaint
    bind -M selection -m default \e end-selection repaint
    bind -M selection -m default \cw kill-selection end-selection repaint
    bind -M selection -m default \ek kill-selection end-selection repaint
end
