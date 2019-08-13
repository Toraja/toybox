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
    bind \e\? __fish_man_page
    bind \e\ci complete-and-search
    bind \cx\cp __fish_paginate
    bind \cx\cl __fish_list_current_token

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
