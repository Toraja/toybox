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

# taskwarrior
set --export TASKRC ~/.config/taskwarrior/taskrc
