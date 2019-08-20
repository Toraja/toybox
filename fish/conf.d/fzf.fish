# variables
set -x FZF_DEFAULT_OPTS "--height=40% --tabstop=4 --multi --reverse --inline-info --preview='bat --color=always {}'
    --bind 'ctrl-alt-n:preview-down,ctrl-alt-p:preview-up'"

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
