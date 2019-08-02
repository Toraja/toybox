function mkdirgo --description 'Create a directory and set CWD'
	command mkdir $argv
	if test $status = 0
		switch $argv[(count $argv)]
			case '-*'
				# last arg was option, do nothing
			case '*'
				cd $argv[(count $argv)]
			return
		end
	end
end
