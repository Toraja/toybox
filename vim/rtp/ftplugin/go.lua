vim.bo.shiftwidth = 4
vim.bo.tabstop = 4

require("keymap.which-key-helper").register_for_ftplugin({
	a = { "GoAltV", { desc = "Alternate file - vertical" } },
	g = { "GoDebug", { desc = "Start debugging" } },
	G = { "GoBreakToggle", { desc = "Toggle break point" } },
	h = { "GoChannel", { desc = "GoChannel" } },
	k = { "GoCallstack", { desc = "GoCallstack" } },
	r = { "GoRun", { desc = "Exec `go run`" } },
	s = { "GoFillStruct", { desc = "Fill struct" } },
	t = { "GoAddTest", { desc = "Add test for this function" } },
	T = { "GoAddTag", { desc = "Add tag to struct" } },
	v = { "GoCoverage", { desc = "Show test coverage" } },
	V = { "GoCoverage -t", { desc = "Load coverage file" } },
	["<Space>t"] = { "lua ginkgo_test_nearest_spec()", { desc = "Test nearest ginkgo spec" } },
	["<Space>T"] = { "lua ginkgo_test_this_file()", { desc = "Test ginkgo specs on this file" } },
	["<Space>g"] = { "lua ginkgo_generate()", { desc = "Generate gingko test file" } },
})

function ginkgo_test_nearest_spec()
	local ginkgo_spec_patterns = {
		'Describe%("(.*)",.*func%(%)%s{',
		'Context%("(.*)",.*func%(%)%s{',
		'It%("(.*)",.*func%(%)%s{',
		'DescribeTable%(\r?\n?%s*"(.*)",', -- this does not match if spec string is on the next line
	}
	local current_line, _ = unpack(vim.api.nvim_win_get_cursor(0))
	local start_line = current_line < 100 and 0 or current_line - 100
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
		print("No spec was found")
		return
	end

	local test_file_path = vim.api.nvim_buf_get_name(0)
	local test_file_basename = vim.fs.basename(test_file_path)
	local test_file_dir = vim.fs.dirname(test_file_path)
	local ginkgo_cmd =
			string.format('ginkgo --focus-file "%s" --focus "%s" %s', test_file_basename, found_spec, test_file_dir)
	-- Without sleep, echoed messsge sometimes is not displayed
	local cmd = "sleep 0.1 && echo '@@@ " .. ginkgo_cmd .. " @@@' && " .. ginkgo_cmd
	require("toggleterm.terminal").Terminal:new({ cmd = cmd, direction = "tab", close_on_exit = false }):toggle()
end

function ginkgo_test_this_file()
	local test_file_path = vim.api.nvim_buf_get_name(0)
	local test_file_basename = vim.fs.basename(test_file_path)
	local test_file_dir = vim.fs.dirname(test_file_path)
	local ginkgo_cmd = string.format('ginkgo --focus-file "%s" %s', test_file_basename, test_file_dir)
	-- Without sleep, echoed messsge sometimes is not displayed
	local cmd = "sleep 0.1 && echo '@@@ " .. ginkgo_cmd .. " @@@' && " .. ginkgo_cmd
	require("toggleterm.terminal").Terminal:new({ cmd = cmd, direction = "tab", close_on_exit = false }):toggle()
end

function ginkgo_generate()
	local file_path = vim.api.nvim_buf_get_name(0)
	local file_basename = vim.fs.basename(file_path)
	local file_dir = vim.fs.dirname(file_path)
	local test_file_path = string.gsub(file_path, ".go", "_test.go")
	local cmd = string.format("ginkgo generate %s", file_basename)
	require("toggleterm.terminal").Terminal
			:new({
				cmd = cmd,
				dir = file_dir,
				direction = "float",
				close_on_exit = true,
				on_exit = function()
					vim.cmd("vnew " .. test_file_path)
				end,
			})
			:toggle()
end

local go_format_augroud_id = vim.api.nvim_create_augroup("go_format", {})
vim.api.nvim_create_autocmd("BufWritePre", {
	group = go_format_augroud_id,
	pattern = "*.go",
	callback = function()
		-- taken from https://github.com/golang/tools/blob/master/gopls/doc/vim.md#neovim-imports
		local params = vim.lsp.util.make_range_params()
		params.context = { only = { "source.organizeImports" } }
		-- buf_request_sync defaults to a 1000ms timeout. Depending on your
		-- machine and codebase, you may want longer. Add an additional
		-- argument after params if you find that you have to write the file
		-- twice for changes to be saved.
		-- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
		local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 2000)
		for cid, res in pairs(result or {}) do
			for _, r in pairs(res.result or {}) do
				if r.edit then
					local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
					vim.lsp.util.apply_workspace_edit(r.edit, enc)
				end
			end
		end
		vim.lsp.buf.format({ async = false })
	end,
})
