vim.bo.shiftwidth = 4
vim.bo.tabstop = 4

require('keymap.which-key-helper').register_with_editable('Go Cmds', '-', '-', {
	a = { 'GoAltV', { desc = 'Alternate file - vertical' } },
	g = { 'GoDebug', { desc = 'Debuger' } },
	G = { 'GoBreakToggle', { desc = 'Toggle break point' } },
	h = { 'GoChannel', { desc = 'GoChannel' } },
	k = { 'GoCallstack', { desc = 'GoCallstack' } },
	l = { 'GoLint', { desc = 'Lint' } },
	r = { 'GoRun -F', { desc = 'Exec `go run`' } },
	s = { 'GoFillStruct', { desc = 'Fill struct' } },
	t = { 'GoAddTest', { desc = 'Add test for this function' } },
	T = { 'GoAddTag', { desc = 'Add tag to struct' } },
	v = { 'GoCoverage', { desc = 'Show test coverage' } },
	V = { 'GoCoverage -t', { desc = 'Load coverage file' } },
	['0'] = { 'GoCodeAction', { desc = 'Code action (go)' } },
	['1'] = { 'GoCodeLenAct', { desc = 'Code lens (go)' } },
})
