# do this on your local file
# eval (keychain --quiet --eval --agents ssh <filename>)

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
# this is set in tmux-sensible but it has not effect on the first window
test $TERM = 'screen'; and set --export TERM 'screen-256color'
functions --query set_display; and set_display # set DISPLAY

# PATH
## local bin
add_path --prepend ~/.local/bin
## Java
add_path --prepend /usr/local/java/bin
## GO
add_path --prepend /usr/local/go/bin $GOPATH/bin

# alias
alias rm='rm -i'
alias cp='cp -ip'
alias mv='mv -i'
alias pd='prevd'
alias nd='nextd'
alias swappiness='cat /proc/sys/vm/swappiness'
alias ll='ls -Ahlv --group-directories-first'
alias vim='vim -p'
type --quiet nvim; and begin
    alias view='nvim -R'
    alias vimdiff='nvim -d'
end

# abbr
if status --is-interactive
## ubuntu
    abbr --add --global apd sudo apt update
    abbr --add --global apg sudo apt upgrade
    abbr --add --global apl apt list
    abbr --add --global aplg apt list --upgradable
## shell
    abbr --add --global mg mkdirgo
    abbr --add --global fig find -type f -exec grep -Hn {} \\\;
## git
    abbr --add --global gb git branch
    abbr --add --global gs git status
    abbr --add --global gl git log
    abbr --add --global glf 'git log --oneline | fzf | awk \'{print $1}\''
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
    abbr --add --global gstl git stash list
    abbr --add --global gstp git stash pop
    abbr --add --global gstm git stash push -m
    abbr --add --global grb git rebase -i
    abbr --add --global grbs git rebase -i --autosquash --autostash
    abbr --add --global grbc git rebase --continue
## docker
    abbr --add --global do docker
    abbr --add --global dob docker build --force-rm -t
    abbr --add --global doc docker container
    abbr --add --global docs docker container ls -a
    abbr --add --global docip docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}'
    abbr --add --global dox docker exec -it
    abbr --add --global dormx docker rm \(docker container ls -a -f status=exited -q\)
    abbr --add --global dormsp docker rm \(docker stop \)
    abbr --add --global doi docker image
    abbr --add --global dois docker images -a
    abbr --add --global doisd docker images -f dangling=true -q
    abbr --add --global dorid docker rmi \(docker images -f dangling=true -q\)
    abbr --add --global dorif docker rmi \(docker images -a -f reference=\'\' -q\)
    abbr --add --global dor docker run -it --name
    abbr --add --global dord docker run -d --name
    abbr --add --global dc docker-compose
    abbr --add --global dcx docker-compose exec
    abbr --add --global dcd docker-compose down -v
    abbr --add --global dcu docker-compose up -d
    abbr --add --global dcub docker-compose up -d --build
    abbr --add --global dcl docker-compose logs --follow
    abbr --add --global dcr docker-compose run
    abbr --add --global dce docker-compose restart
## go
    abbr --add --global got go test
    abbr --add --global gotr go test -run
end

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
