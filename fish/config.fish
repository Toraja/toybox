# do this on your local file
# eval (keychain --quiet --eval --agents ssh <filename>)

tabs 4

# Environment variables
set -x EDITOR vim
set -x VISUAL vim
set -x GOPATH $HOME/go
# this is set in tmux-sensible but it has not effect on the first window
test $TERM = 'screen'; and set -x TERM 'screen-256color'

# PATH
test -d /usr/local/go; and not contains /usr/local/go/bin $PATH; and set -xp PATH /usr/local/go/bin
not contains $GOPATH/bin $PATH; and set -xp PATH $GOPATH/bin

# fish variables
set fish_conf $__fish_config_dir/config.fish
set fish_myfuncs $__fish_config_dir/myfuncs
not contains $fish_myfuncs $fish_function_path; and set -p fish_function_path $fish_myfuncs
set fish_prompt_pwd_dir_length 5 # setting to 0 disable shortening path in prompt_pwd

# alias
alias rm='rm -i'
alias cp='cp -ip'
alias mv='mv -i'
alias pd='prevd'
alias nd='nextd'
alias swappiness='cat /proc/sys/vm/swappiness'
alias ll='ls -Ahlv'
alias vim='vim -p'
type -q nvim; and begin
    alias view='nvim -R'
    alias vimdiff='nvim -d'
end

# abbr
# fish
abbr --add --global mg mkdirgo
## git
abbr --add --global gb git branch
abbr --add --global gs git status
abbr --add --global gl git log
abbr --add --global gd git diff
abbr --add --global gdc git diff --cached
abbr --add --global gdt git difftool
abbr --add --global gdtc git difftool --cached
abbr --add --global ga git add
abbr --add --global gai git add -i
abbr --add --global gcm git commit -m
abbr --add --global gco git checkout
abbr --add --global gr git reset
abbr --add --global gst git stash
abbr --add --global gstp git stash pop
abbr --add --global gstm git stash push -m
abbr --add --global grb git rebase -i
## docker
abbr --add --global dc docker-compose
abbr --add --global dcx docker-compose exec
abbr --add --global dcd docker-compose down -v
abbr --add --global dcu docker-compose up -d\; docker-compose logs --follow
abbr --add --global dcr docker-compose restart
## go
abbr --add --global got go test
abbr --add --global gotr go test -run

# fzf
## variables
set -l fzf_opts "--height=40%"\
    "--tabstop=4"\
    "--multi" \
    "--reverse" \
    "--inline-info" \
    "--preview='bat --color=always {}'"
set -l fzf_bind_opts "alt-n:preview-down" \
    "alt-p:preview-up" \
    "alt-h:backward-kill-word" \
    "ctrl-k:kill-line" \
    "ctrl-v:page-down" \
    "alt-v:page-up" \
    "ctrl-t:top"
set -x FZF_DEFAULT_OPTS (string join -- " " $fzf_opts "--bind="(string join ',' $fzf_bind_opts))

## bindings
# As my fish_user_key_bindings predates, fzf_key_bindings is not called automatically
functions -q fzf_key_bindings; and fzf_key_bindings
# and test (bind \ct | awk '{print $3}') = 'fzf-file-widget' # somehow fails (succeeds on command line)
and begin
    bind \ct transpose-chars
    bind \ec capitalize-word
    bind \co fzf-file-widget
    bind \eo fzf-cd-widget
end
