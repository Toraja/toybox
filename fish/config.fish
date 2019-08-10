tabs 4

# Environment variables
set -x EDITOR vim
set -x VISUAL vim
set -x GOPATH $HOME/go

# PATH
not contains $GOPATH/bin $PATH; and set -xp PATH $GOPATH/bin

# fish variables
set fish_conf $__fish_config_dir/config.fish
set fish_myfuncs $__fish_config_dir/myfuncs
not contains $fish_myfuncs $fish_function_path; and set -p fish_function_path $fish_myfuncs
set fish_prompt_pwd_dir_length 0 # disable shortening path in prompt_pwd

# alias
alias rm='rm -i'
alias cp='cp -ip'
alias mv='mv -i'
alias pd='prevd'
alias nd='nextd'
alias swappiness='cat /proc/sys/vm/swappiness'
alias ll='ls -Ahlv'
alias vim='vim -p'
if test (which nvim)
    alias view='nvim -R'
    alias vimdiff='nvim -d'
end

# abbr
## git
abbr --add --global gb git branch
abbr --add --global gs git status
abbr --add --global gl git log
abbr --add --global gd git git diff
abbr --add --global gdc git diff --cached
abbr --add --global ga git add
abbr --add --global gal git add .
abbr --add --global gcm git commit -m
abbr --add --global gco git checkout
abbr --add --global gst git stash
abbr --add --global gsp git stash pop
abbr --add --global gstm git stash push -m
## docker
abbr --add --global dc docker-compose
abbr --add --global dcx docker-compose exec
abbr --add --global dcd docker-compose down -v
abbr --add --global dcu docker-compose up -d\; docker-compose logs --follow
abbr --add --global dcr docker-composer restart
## go
abbr --add --global got go test
abbr --add --global gotr go test -run
