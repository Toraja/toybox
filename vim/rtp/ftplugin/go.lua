vim.bo.shiftwidth = 4
vim.bo.tabstop = 4

require('keymap.which-key-helper').register_for_ftplugin({
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
	['<C-t>'] = { 'lua ginkgo_run_nearest_spec()', { desc = 'Run nearest ginkgo spec' } },
	v = { 'GoCoverage', { desc = 'Show test coverage' } },
	V = { 'GoCoverage -t', { desc = 'Load coverage file' } },
})

function ginkgo_run_nearest_spec()
	local ginkgo_spec_patterns = {
		'Describe%("(.*)",.*func%(%)%s{',
		'Context%("(.*)",.*func%(%)%s{',
		'It%("(.*)",.*func%(%)%s{',
	}
	local current_line, _ = unpack(vim.api.nvim_win_get_cursor(0))
	local start_line = current_line - 60
	local lines = vim.api.nvim_buf_get_lines(0, start_line, current_line, true)
	local function find_spec()
		for i = #lines, 1, -1 do
			local line = lines[i]
			for _, pattern in ipairs(ginkgo_spec_patterns) do
				local spec = string.match(line, pattern)
				if spec ~= nil then
					return spec
				end
			end
		end
	end
	local spec = find_spec()
	print(spec)

	local test_file_basename = vim.fn.expand('%:t')
	local test_file_dir = vim.fn.expand('%:h')
	local ginkgo_cmd = string.format('ginkgo --focus-file "%s" --focus "%s" %s', test_file_basename, spec, test_file_dir)
	local cmd = "echo '@@@ " .. ginkgo_cmd .. " @@@' && " .. ginkgo_cmd
	require('toggleterm.terminal').Terminal:new({ cmd = cmd, direction = 'tab', close_on_exit = false }):toggle()
end
