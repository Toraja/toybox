if not type --quiet fzf
    echo "$(realpath --no-symlink $(status --current-filename)): fzf is not in the PATH"
    exit
end

set --local fzf_previewer (type -q bat; and echo bat; or echo cat)
set --local fzf_opts "--height=50%" \
    "--tabstop=4" \
    --multi \
    --reverse \
    --inline-info \
    "--preview='$fzf_previewer --color=always {}'" \
    "--preview-window=hidden"
set --local fzf_bind_opts "ctrl-space:toggle" \
    "ctrl-i:down" \
    "ctrl-j:toggle-out" \
    "ctrl-alt-j:toggle-in" \
    "ctrl-o:first" \
    "alt-o:last" \
    "ctrl-s:jump" \
    "ctrl-/:toggle-preview" \
    "alt-j:preview-half-page-down" \
    "alt-k:preview-half-page-up" \
    "alt-g:preview-top" \
    "alt-G:preview-bottom" \
    "alt-h:backward-kill-word" \
    "ctrl-k:kill-line"
set --export FZF_DEFAULT_COMMAND "fd --hidden --exclude .git"
set --export FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND --search-path \$dir"
set --export FZF_DEFAULT_OPTS (string join -- " " $fzf_opts "--bind="(string join ',' $fzf_bind_opts))

# fzf
if functions --query fzf_key_bindings
    bind ctrl-o fzf-file-widget
    bind alt-o fzf-cd-widget
end
