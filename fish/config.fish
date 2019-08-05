tabs 4

# Defined here as this func is needed inside this file
# Requires fish v3
function add_unique --description "add values to list if not contained, appending by default"
	argparse --name=add_unique --min-args=2 -x p,a 'p/prepend' 'a/append' -- $argv
	or return 1

	set listname $argv[1]
	set list (eval echo '$'$listname)
	set values $argv[2..-1]

	for v in $values
		contains $v $list; and set -a new_values $v
	end

	test -n "$_flag_prepend"
		and set -gp $listname $new_values
		or set -ga $listname $new_values
end

# Environment variables
set -x EDITOR vim
set -x VISUAL vim
set -x GOPATH $HOME/go

# PATH
# add_unique -p PATH $GOPATH
not contains $GOPATH $PATH; and set -x PATH $GOPATH $PATH

# fish variables
set fish_dir ~/.config/fish
set fish_conf $fish_dir/config.fish
set fish_myfuncs $fish_dir/myfuncs
# add_unique -p fish_function_path $fish_myfuncs
set fish_function_path $fish_myfuncs $fish_function_path
set fish_prompt_pwd_dir_length 0 # disable shortening path in prompt_pwd

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
