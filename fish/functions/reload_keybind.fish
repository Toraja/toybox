function reload_keybind
    # Clear commandline first to prevent a command from being executed if commandline buffer contains something
    commandline --function clear-commandline
    fish_user_key_bindings
    # XXX: When commandline buffer contains something, that hides the left side of the below messages.
    # Appending (not prepending) spaces somehow unhides the messages.
    and printf '%s %s' '[ reloaded keybind ]' $(string repeat --count 30 ' ')
    or printf '%s %s' '[ failed to reloaded keybind ]' $(string repeat --count 30 ' ')
    commandline --function execute
end
