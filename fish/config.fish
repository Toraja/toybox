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

bind \e\? __fish_man_page
bind \e\ci complete-and-search
bind \e\cf forward-bigword
bind \e\cb backward-bigword
bind \eh backward-kill-word
bind \e\ch backward-kill-word

bind \cv begin-selection
bind \co swap-selection-start-stop repaint
bind \cx end-selection repaint
bind \ek kill-selection end-selection repaint

if set -q TMUX
	set -g copycmd 'tmux load-buffer -'
else if test -f /mnt/c/Windows/System32/clip.exe
	set -g copycmd 'clip.exe'
else if string match -qr xterm $TERM
	set -g copycmd 'xclip -selection c'
end

if set -q copycmd
	bind \cq "commandline -a \" | $copycmd\""
	bind \eq wrap_in_echo_single
	bind \e\cq wrap_in_echo_double
end

# Leave this as reference about different mode
# Need to bind <BS>, <DEL> and arrow keys etc as self-insert for those just input weird chars
# bind -M selection '' self-insert
# bind -m selection \cv begin-selection
# bind -M selection -m default \eo swap-selection-start-stop repaint
# bind -M selection -m default \ex end-selection repaint
# bind -M selection -m default \ek kill-selection end-selection repaint
