function fish_prompt --description 'Write out the prompt'
	set symbol '$'
	if test $USER = 'root'
		set symbol '#'
	end

	echo (set_color cyan)fish:(set_color green)$USER:$SHLVL:(prompt_pwd)(set_color normal)\n$symbol' '
end
