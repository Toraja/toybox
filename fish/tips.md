# Fish

## Profile load order
Variables/functions etc. declared in subsequent files cannot be used in preceding files.
ref: https://github.com/fish-shell/fish-shell/issues/8553

1. `~/.config/fish/conf.d/*.fish`
2. `/etc/fish/conf.d/*.fish`
3. Vendor conf.d directories
4. `~/.config/fish/config.fish`
5. `~/.config/fish/functions/*.fish` (including `fish_user_key_bindings.fish`)
