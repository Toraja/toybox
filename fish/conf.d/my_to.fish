# Overwrite default bookmark location of to-fish
if test -d ~/workspace
    if  not test -d ~/workspace/config/fish/
        mkdir -p ~/workspace/config/fish/
    end
    set -U TO_DIR ~/workspace/config/fish/tofish
else
    set -U TO_DIR ~/.local/share/fish/tofish
end
