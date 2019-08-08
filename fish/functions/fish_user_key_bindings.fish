function fish_user_key_bindings
    # motion
    bind \e\cf forward-bigword
    bind \e\cb backward-bigword
    bind \x1D forward-jump
    bind \e\x1D backward-jump

    # edit
    bind \eh backward-kill-word

    # search
    bind \ep history-token-search-backward
    bind \en history-token-search-forward

    # selection
    bind \cv begin-selection
    bind \cx\cx swap-selection-start-stop repaint
    bind \cx\x20 end-selection repaint
    bind \ek kill-selection end-selection repaint

    # misc
    bind \e\? __fish_man_page
    bind \e\ci complete-and-search
    bind \e\\ __fish_paginate

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

    # Leave this as reference about different mode
    # Need to bind <BS>, <DEL> and arrow keys etc as self-insert for those just input weird chars
    # bind -M selection '' self-insert
    # bind -m selection \cv begin-selection
    # bind -M selection -m default \eo swap-selection-start-stop repaint
    # bind -M selection -m default \ex end-selection repaint
    # bind -M selection -m default \ek kill-selection end-selection repaint
end
