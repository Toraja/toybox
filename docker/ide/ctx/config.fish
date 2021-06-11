source ~/toybox/fish/config.fish

if status --is-interactive
    # GIT_HUB_SSH_KEY is set in .env
    keychain --quiet --agents ssh ~/.ssh/$GIT_HUB_SSH_KEY

    begin
        set -l HOSTNAME (hostname)
        if test -f ~/.keychain/$HOSTNAME-fish
            source ~/.keychain/$HOSTNAME-fish
        end
    end
end

