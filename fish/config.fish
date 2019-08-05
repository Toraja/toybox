tabs 4

# Environment variables
set -x EDITOR vim
set -x VISUAL vim
set -x GOPATH $HOME/go

# PATH
not contains $GOPATH $PATH; and set -x PATH $GOPATH $PATH

# fish variables
set fish_conf $__fish_config_dir/config.fish
set fish_myfuncs $__fish_config_dir/myfuncs
set fish_function_path $fish_myfuncs $fish_function_path
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
