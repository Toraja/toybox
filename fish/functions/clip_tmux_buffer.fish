function clip_tmux_buffer --description 'copy tmux buffer to clipboard'
    read stdin
    echo -n $stdin | tmux load-buffer -
    # $clipbin is set inside fish_user_key_bindings()
    # Somehow empty pipe is fine if it is a result of `eval`
    # (stdin will be discarded)
    # Mere variable expansion (without `eval`) results in error
    echo -n $stdin | eval $clipbin
end
