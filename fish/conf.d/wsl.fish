if ! grep -qEi "(Microsoft|WSL)" /proc/version
    exit
end

# function is not loaded by the time this file is loaded
# so `add_path` function cannot be used.
test -d /mnt/c/Program\ Files/Mozilla\ Firefox; and begin
    set --prepend PATH /mnt/c/Program\ Files/Mozilla\ Firefox
    abbr --add --global ff firefox.exe
    abbr --add --global ffw firefox.exe -new-window
    abbr --add --global ffp firefox.exe -private-window
end
