function reload_keybind
    commandline --replace ''
    fish_user_key_bindings
    # add trailing spaces so that messages will not cut off when buffer contains something
    and echo -n 'reloaded keybind               '
    or echo -n 'failed to reload keybind               '
    commandline --function execute
end
