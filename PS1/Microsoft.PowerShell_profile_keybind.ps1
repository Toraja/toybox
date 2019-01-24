# <Key Bindings>
# Mode
Set-PSReadlineOption -EditMode Emacs
Set-PSReadlineOption -BellStyle None
# Customization
## Completion
Set-PSReadlineKeyHandler -Chord Ctrl+i -Function Complete
Set-PSReadlineKeyHandler -Chord Alt+i -Function MenuComplete
Set-PSReadlineKeyHandler -Chord Ctrl+j -Function TabCompleteNext
Set-PSReadlineKeyHandler -Chord Alt+j -Function TabCompletePrevious
## History
Set-PSReadlineKeyHandler -Chord Alt+n -Function HistorySearchForward
Set-PSReadlineKeyHandler -Chord Alt+p -Function HistorySearchBackward
## Motion
Set-PSReadlineKeyHandler -Chord Ctrl+Alt+f -Function ShellForwardWord
Set-PSReadlineKeyHandler -Chord Ctrl+Alt+b -Function ShellBackwardWord
Set-PSReadlineKeyHandler -Chord Ctrl+5 -Function GotoBrace
## Scrolling
Set-PSReadlineKeyHandler -Chord Shift+UpArrow -Function ScrollDisplayUpLine
Set-PSReadlineKeyHandler -Chord Shift+DownArrow -Function ScrollDisplayDownLine
Set-PSReadlineKeyHandler -Chord Ctrl+v -Function ScrollDisplayDown
Set-PSReadlineKeyHandler -Chord Alt+v -Function ScrollDisplayUp
## Editing
Set-PSReadlineKeyHandler -Chord Alt+h -Function BackwardKillWord
Set-PSReadlineKeyHandler -Chord Ctrl+Alt+h -BriefDescription Unix-filename-rubout -Description "Move the test between the cursor and previous slash to the kill ring" -ScriptBlock {param($key, $arg); Windows-Filename-Rubout -key $key -arg $arg}
Set-PSReadlineKeyHandler -Chord Ctrl+Alt+d -Function ShellKillWord
Set-PSReadlineKeyHandler -Chord Ctrl+Alt+u -BriefDescription KillWholeLine -Description "Move the whole line text to the kill ring" -ScriptBlock { [Microsoft.PowerShell.PSConsoleReadLine]::BackwardKillLine(); [Microsoft.PowerShell.PSConsoleReadLine]::KillLine() }
Set-PSReadlineKeyHandler -Chord Alt+k -Function KillRegion
Set-PSReadlineKeyHandler -Chord Ctrl+/ -Function Undo
Set-PSReadlineKeyHandler -Chord Alt+/ -Function Redo
Set-PSReadlineKeyHandler -Chord Alt+m -Function InsertLineBelow
Set-PSReadlineKeyHandler -Chord Ctrl+Alt+m -Function InsertLineAbove
## Select
Set-PSReadlineKeyHandler -Chord Ctrl+Shift+a -Function SelectBackwardsLine
Set-PSReadlineKeyHandler -Chord Ctrl+Shift+e -Function SelectLine
Set-PSReadlineKeyHandler -Chord Ctrl+Shift+f -Function SelectForwardChar
Set-PSReadlineKeyHandler -Chord Ctrl+Shift+b -Function SelectBackwardChar
Set-PSReadlineKeyHandler -Chord "Ctrl+x,h","Ctrl+x,Ctrl+h" -Function SelectAll
## Cut/Copy/Paste
Set-PSReadlineKeyHandler -Chord Ctrl+Shift+x -Function Cut
Set-PSReadlineKeyHandler -Chord Ctrl+Shift+c -Function Copy
Set-PSReadlineKeyHandler -Chord Ctrl+Shift+v -Function Paste
Set-PSReadlineKeyHandler -Chord Shift+Insert -Function Paste
## Search
Set-PSReadlineKeyHandler -Chord Ctrl+] -Function SearchChar
Set-PSReadlineKeyHandler -Chord Ctrl+Alt+] -Function SearchCharBackward
Set-PSReadlineKeyHandler -Chord Ctrl+\ -Function RepeatLastCharSearch
Set-PSReadlineKeyHandler -Chord Ctrl+Shift+\ -Function RepeatLastCharSearchBackwards
## Misc
Set-PSReadlineKeyHandler -Chord Ctrl+Spacebar -Function SetMark
Set-PSReadlineKeyHandler -Chord Ctrl+t -Function SwapCharacters

## Text Insertion
### Re-read init file ($PROFILE)
Set-PSReadlineKeyHandler -Chord "Ctrl+x,Ctrl+r" -BriefDescription Re-ReadInitFile -Description "Read the profile again" -ScriptBlock{
	[Microsoft.PowerShell.PSConsoleReadLine]::BackwardKillLine()
	[Microsoft.PowerShell.PSConsoleReadLine]::KillLine()
	[Microsoft.PowerShell.PSConsoleReadLine]::Insert('. $PROFILE')
	[Microsoft.PowerShell.PSConsoleReadLine]::ValidateAndAcceptLine()
}
### insert space after cursor
Set-PSReadlineKeyHandler -Chord "Ctrl+x,Ctrl+Spacebar" -BriefDescription SpaceAfterCursor -Description "Insert space after cursor" -ScriptBlock {
	[Microsoft.PowerShell.PSConsoleReadLine]::Insert(' ')
	[Microsoft.PowerShell.PSConsoleReadLine]::BackwardChar()
}

Set-PSReadlineKeyHandler -Chord Alt+# -BriefDescription ToggleComment -Description "Insert or delete comment at the beginning of the line" -ScriptBlock {
	$line = $null
	$cursor = $null
	[Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition(0)
	[Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
	if($line[0] -eq '#'){
		[Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
		[Microsoft.PowerShell.PSConsoleReadLine]::Insert($line.substring(1))
	}
	else{
		[Microsoft.PowerShell.PSConsoleReadLine]::Insert('#')
	}
	[Microsoft.PowerShell.PSConsoleReadLine]::ValidateAndAcceptLine()
}

Set-PSReadlineKeyHandler -Chord 'Alt+;' -BriefDescription PipeForEach -Description "Insert Pipe and ForEach block" -ScriptBlock{
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert('| %{ $_}')
	foreach ( $i in 1..4 ) {
		[Microsoft.PowerShell.PSConsoleReadLine]::BackwardChar()
	}
}

Set-PSReadlineKeyHandler -Chord "Alt+:" -BriefDescription PipeWhere -Description "Insert Pipe and Where block" -ScriptBlock{
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert('| ?{$_}')
	[Microsoft.PowerShell.PSConsoleReadLine]::BackwardChar()
}

Set-PSReadlineKeyHandler -Chord Ctrl+q -BriefDescription PipeToClip -Description "Redirect Stdout to Clipboard" -ScriptBlock{
	[Microsoft.PowerShell.PSConsoleReadLine]::EndOfLine()
	[Microsoft.PowerShell.PSConsoleReadLine]::Insert(' | Set-Clipboard')
}

Set-PSReadlineKeyHandler -Chord Alt+q -BriefDescription PipeToClipSingleQuote -Description "Wrap whole line with single quote and redirect Stdout to Clipboard" -ScriptBlock{
	[Microsoft.PowerShell.PSConsoleReadLine]::BeginningOfLine()
	[Microsoft.PowerShell.PSConsoleReadLine]::Insert("'")
	[Microsoft.PowerShell.PSConsoleReadLine]::EndOfLine()
	[Microsoft.PowerShell.PSConsoleReadLine]::Insert("' | Set-Clipboard")
}

Set-PSReadlineKeyHandler -Chord Ctrl+Alt+q -BriefDescription PipeToClipDoubleQuote -Description "Wrap whole line with double quote and redirect Stdout to Clipboard" -ScriptBlock{
	[Microsoft.PowerShell.PSConsoleReadLine]::BeginningOfLine()
	[Microsoft.PowerShell.PSConsoleReadLine]::Insert('"')
	[Microsoft.PowerShell.PSConsoleReadLine]::EndOfLine()
	[Microsoft.PowerShell.PSConsoleReadLine]::Insert('" | Set-Clipboard')
}

Set-PSReadlineKeyHandler -Chord "Alt+(" -BriefDescription WrapWholeInParenthesesCursorTop -Description "Wrap whole line in Parentheses and move cursor to the top" -ScriptBlock {
	[Microsoft.PowerShell.PSConsoleReadLine]::BeginningOfLine()
	[Microsoft.PowerShell.PSConsoleReadLine]::Insert('(')
	[Microsoft.PowerShell.PSConsoleReadLine]::EndOfLine()
	[Microsoft.PowerShell.PSConsoleReadLine]::Insert(')')
	[Microsoft.PowerShell.PSConsoleReadLine]::BeginningOfLine()
}

Set-PSReadlineKeyHandler -Chord "Alt+)" -BriefDescription WrapWholeInParenthesesCursorEnd -Description "Wrap whole line in Parentheses and move cursor to the end" -ScriptBlock {
	[Microsoft.PowerShell.PSConsoleReadLine]::BeginningOfLine()
	[Microsoft.PowerShell.PSConsoleReadLine]::Insert('(')
	[Microsoft.PowerShell.PSConsoleReadLine]::EndOfLine()
	[Microsoft.PowerShell.PSConsoleReadLine]::Insert(')')
	[Microsoft.PowerShell.PSConsoleReadLine]::EndOfLine()
}

Set-PSReadlineKeyHandler -Chord "Ctrl+x,Ctrl+0" -BriefDescription WrapLineInParentheses -Description "Wrap from the cursor position to the end of the line in Parentheses" -ScriptBlock {
	$line = $null
	$cursor = $null
	[Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
	[Microsoft.PowerShell.PSConsoleReadLine]::Insert(' (')
	[Microsoft.PowerShell.PSConsoleReadLine]::EndOfLine()
	[Microsoft.PowerShell.PSConsoleReadLine]::Insert(')')
	[Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($cursor)
}

Set-PSReadlineKeyHandler -Chord "Ctrl+x,Ctrl+9" -BriefDescription WrapLineInParenthesesBackword -Description "Wrap from the cursor position to the beginning of the line in Parentheses" -ScriptBlock {
	$line = $null
	$cursor = $null
	[Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
	[Microsoft.PowerShell.PSConsoleReadLine]::BeginningOfLine()
	[Microsoft.PowerShell.PSConsoleReadLine]::Insert('(')
	[Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($cursor + 1)
	[Microsoft.PowerShell.PSConsoleReadLine]::Insert(')')
}

Set-PSReadlineKeyHandler -Chord "Alt+e" -BriefDescription EnvPrefix -Description "Insert '`$env:'" -ScriptBlock {
	[Microsoft.PowerShell.PSConsoleReadLine]::Insert('$env:')
}

## Helper function for ReadLine
function Windows-Filename-Rubout{
	param($key, $arg)

	# XXX this behaves differently when consecutive slash or space are present
	$line = $null
	$cursor = 0
	[Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
	$separators = (Select-String -Pattern '\\|/| ' -InputObject $line -AllMatches).Matches
	# Adjust the position to look for the char. $cursor-1 is the char just in front of cursor.
	# Without this, if the char in front of cursor is '\' or ' ', this command will not delete anything.
	$columnToMove = 0
	if ($separators -ne $null) {
		if ($columnToMove = $separators[-1].Index -ne $cursor - 1) {	# last separator is not in front of the cursor
			$columnToMove = $separators[-1].Index + 1
		} elseif ($separators.Length -gt 1) {							# if more than one separator, go to the previous one
			$columnToMove = $separators[-2].Index + 1
		}
		# [else] If the separator found is only the one in front of cursor, delete to the beginning
		# ($columnToMove should be 0)
	}
	# --- old code: delete if it's working properly ---
	# $lastIndexEndPos = 0
	# $previousSlashPos = 0
	# $previousSpacePos = 0
	# $columnToMove = 0
	# Adjust the position to look for the char. $cursor-1 is the char just in front of cursor.
	# Without this, if the char in front of cursor is '\' or ' ', this command will not delete anything.
	# [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
	# if (($cursor - 2) -lt 0){
	#     $lastIndexEndPos = 0
	# }
	# else {
	#     $lastIndexEndPos = $cursor - 2
	# }
	# $previousSlashPos = $line.LastIndexOf('\', $lastIndexEndPos)
	# $previousSpacePos = $line.LastIndexOf(' ', $lastIndexEndPos)
	# $columnToMove = if ($previousSlashPos -ge $previousSpacePos) {$previousSlashPos} else {$previousSpacePos}
	# $columnToMove++
	# -------------------------------------------------
	[Microsoft.PowerShell.PSConsoleReadLine]::SetMark()
	[Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($columnToMove)
	[Microsoft.PowerShell.PSConsoleReadLine]::KillRegion()
}

