# do this on your local file
# # if status --is-interactive
#     if test -f <filename>
#         keychain --quiet --agents ssh <filename>
#     end
#     begin
#         set --local HOSTNAME (hostname)
#         if test -f ~/.keychain/$HOSTNAME-fish
#             source ~/.keychain/$HOSTNAME-fish
#         end
#     end
# end

tabs 4

# fish variables
set fish_conf $__fish_config_dir/config.fish
set fish_myfuncs $__fish_config_dir/myfuncs
# add_unique is not available here
if not contains $fish_myfuncs $fish_function_path
    set --prepend fish_function_path $fish_myfuncs
end
set fish_prompt_pwd_dir_length 0 # setting to 0 disable shortening path in prompt_pwd

# Environment variables
set --export EDITOR 'nvim -p'
set --export VISUAL 'nvim -p'
set --export DOCKER_BUILDKIT 1
set --export LIBGL_ALWAYS_INDIRECT 1 # this might improve GUI performance
switch $TERM
    case xterm
        # This is required to enable 256 color inside tmux on docker container
        set --export TERM xterm-256color
    case screen
        # this is set in tmux-sensible but it has not effect on the first window
        set --export TERM screen-256color
end
if functions --query set_display
    set_display
end
set --export LESS iR

# PATH
## local bin
fish_add_path --prepend ~/.local/bin

# alias
alias rm='rm -i'
alias cp='cp -ip'
alias mv='mv -i'
alias pd='prevd'
alias nd='nextd'
alias swappiness='cat /proc/sys/vm/swappiness'
function ll
    ls -Ahlv --group-directories-first --color=always $argv | less -FiRX
end
if type --quiet nvim
    alias vim='nvim -p'
    alias view='nvim -R'
    alias vimdiff='nvim -d'
end

# abbr defined in conf.d/abbr.fish

# fzf
## variables
if type --quiet fzf
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
    if type --query fd
        set --export FZF_DEFAULT_COMMAND "fd --hidden --exclude .git"
        set --export FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND --search-path \$dir"
    end
    set --export FZF_DEFAULT_OPTS (string join -- " " $fzf_opts "--bind="(string join ',' $fzf_bind_opts))
    fzf --fish | FZF_CTRL_T_COMMAND= FZF_ALT_C_COMMAND= source
end

# taskwarrior
set --export TASKRC ~/.config/taskwarrior/taskrc
