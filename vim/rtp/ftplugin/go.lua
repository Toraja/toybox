vim.bo.shiftwidth = 4
vim.bo.tabstop = 4

require('keymap.which-key-helper').register_for_ftplugin({
	a = { 'GoAltV', { desc = 'Alternate file - vertical' } },
	g = { 'GoDebug', { desc = 'Debuger' } },
	G = { 'GoBreakToggle', { desc = 'Toggle break point' } },
	h = { 'GoChannel', { desc = 'GoChannel' } },
	k = { 'GoCallstack', { desc = 'GoCallstack' } },
	l = { 'GoLint', { desc = 'Lint' } },
	r = { 'GoRun', { desc = 'Exec `go run`' } },
	s = { 'GoFillStruct', { desc = 'Fill struct' } },
	t = { 'GoAddTest', { desc = 'Add test for this function' } },
	T = { 'GoAddTag', { desc = 'Add tag to struct' } },
	['<C-t>'] = { 'lua ginkgo_test_nearest_spec()', { desc = 'Test nearest ginkgo spec' } },
	['<M-t>'] = { 'lua ginkgo_test_this_file()', { desc = 'Test ginkgo specs on this file' } },
	v = { 'GoCoverage', { desc = 'Show test coverage' } },
	V = { 'GoCoverage -t', { desc = 'Load coverage file' } },
})

function ginkgo_test_nearest_spec()
	local ginkgo_spec_patterns = {
		'Describe%("(.*)",.*func%(%)%s{',
		'Context%("(.*)",.*func%(%)%s{',
		'It%("(.*)",.*func%(%)%s{',
	}
	local current_line, _ = unpack(vim.api.nvim_win_get_cursor(0))
	local start_line = current_line < 60 and 0 or current_line - 60
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
	local found_spec = find_spec()
	if found_spec == nil then
		print('No spec was found')
		return
	end

	local test_file_path = vim.api.nvim_buf_get_name(0)
	local test_file_basename = vim.fs.basename(test_file_path)
	local test_file_dir = vim.fs.dirname(test_file_path)
	local ginkgo_cmd = string.format('ginkgo --focus-file "%s" --focus "%s" %s', test_file_basename, found_spec,
		test_file_dir)
	-- Without sleep, echoed messsge sometimes is not displayed
	local cmd = "sleep 0.1 && echo '@@@ " .. ginkgo_cmd .. " @@@' && " .. ginkgo_cmd
	require('toggleterm.terminal').Terminal:new({ cmd = cmd, direction = 'tab', close_on_exit = false }):toggle()
end

function ginkgo_test_this_file()
	local test_file_path = vim.api.nvim_buf_get_name(0)
	local test_file_basename = vim.fs.basename(test_file_path)
	local test_file_dir = vim.fs.dirname(test_file_path)
	local ginkgo_cmd = string.format('ginkgo --focus-file "%s" %s', test_file_basename, test_file_dir)
	-- Without sleep, echoed messsge sometimes is not displayed
	local cmd = "sleep 0.1 && echo '@@@ " .. ginkgo_cmd .. " @@@' && " .. ginkgo_cmd
	require('toggleterm.terminal').Terminal:new({ cmd = cmd, direction = 'tab', close_on_exit = false }):toggle()
end
