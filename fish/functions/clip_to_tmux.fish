function clip_to_tmux --description 'send stdin to tmux buffer and clipboard (if any command is available)'
    read stdin
    echo -n $stdin | tmux load-buffer -w -
end
