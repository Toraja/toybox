# do this on your local file
# if status --is-interactive
#     keychain --quiet --agents ssh <filename>
# end
#
# begin
#     set -l HOSTNAME (hostname)
#     if test -f ~/.keychain/$HOSTNAME-fish
#         source ~/.keychain/$HOSTNAME-fish
#     end
# end

tabs 4

# fish variables
set fish_conf $__fish_config_dir/config.fish
set fish_myfuncs $__fish_config_dir/myfuncs
# add_unique is not available here
not contains $fish_myfuncs $fish_function_path; and set --prepend fish_function_path $fish_myfuncs
set fish_prompt_pwd_dir_length 5 # setting to 0 disable shortening path in prompt_pwd

# Environment variables
set --export EDITOR vim
set --export VISUAL vim
set --export GOPATH $HOME/go
switch $TERM
    case 'xterm'
        # This is required to enable 256 color inside tmux on docker container
        set --export TERM 'xterm-256color'
    case 'screen'
        # this is set in tmux-sensible but it has not effect on the first window
        set --export TERM 'screen-256color'
end
functions --query set_display; and set_display # set DISPLAY

# PATH
## local bin
add_path --prepend ~/.local/bin
## Java
add_path --prepend /usr/local/java/bin
## PHP
add_path --prepend ~/.composer/vendor/bin ~/.config/composer/vendor/bin # version 1 / 2
## GO
add_path --prepend /usr/local/go/bin $GOPATH/bin # some tools in GOPATH needs to be run

# alias
alias rm='rm -i'
alias cp='cp -ip'
alias mv='mv -i'
alias pd='prevd'
alias nd='nextd'
alias swappiness='cat /proc/sys/vm/swappiness'
alias ll='ls -Ahlv --group-directories-first'
type --quiet nvim; and begin
    alias vim='nvim -p'
    alias view='nvim -R'
    alias vimdiff='nvim -d'
end
alias fugitive 'vim -c 0Git'

# abbr defined in conf.d/abbr.fish

# fzf
## variables
set --local fzf_opts "--height=40%"\
    "--tabstop=4"\
    "--multi" \
    "--reverse" \
    "--inline-info" \
    "--preview='bat --color=always {}'" \
    "--preview-window=hidden"
set --local fzf_bind_opts "ctrl-space:toggle" \
    "ctrl-o:top" \
    "ctrl-s:jump" \
    "alt-/:toggle-preview" \
    "alt-n:preview-down" \
    "alt-p:preview-up" \
    "ctrl-v:preview-page-down" \
    "alt-v:preview-page-up" \
    "alt-h:backward-kill-word" \
    "ctrl-k:kill-line"
set --export FZF_DEFAULT_OPTS (string join -- " " $fzf_opts "--bind="(string join ',' $fzf_bind_opts))

## bindings
# As my fish_user_key_bindings predates, fzf_key_bindings is not called automatically
functions --query fzf_key_bindings; and fzf_key_bindings
# and test (bind \ct | awk '{print $3}') = 'fzf-file-widget' # somehow fails (succeeds on command line)
and begin
    bind \ct transpose-chars
    bind \ec capitalize-word
    bind \co fzf-file-widget
    bind \eo fzf-cd-widget
end
