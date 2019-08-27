# variables
set -l fzf_opts "--height=40%"\
    "--tabstop=4"\
    "--multi" \
    "--reverse" \
    "--inline-info" \
    "--preview='bat --color=always {}'"
set -l fzf_bind_opts "ctrl-alt-n:preview-down" \
    "ctrl-alt-p:preview-up"
set -x FZF_DEFAULT_OPTS (string join -- " " $fzf_opts "--bind="(string join ',' $fzf_bind_opts))

# bindings
# As my fish_user_key_bindings predates, fzf_key_bindings is not called automatically
functions -q fzf_key_bindings; and fzf_key_bindings
# and test (bind \ct | awk '{print $3}') = 'fzf-file-widget' # somehow fails (succeeds on command line)
and begin
    bind \ct transpose-chars
    bind \ec capitalize-word
    bind \co fzf-file-widget
    bind \eo fzf-cd-widget
end
