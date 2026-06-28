require("text.edit").map_toggle_trailing(";", ";", true)

local function rust_toggle_back_trace()
	vim.env.RUST_BACKTRACE = 1 - (vim.env.RUST_BACKTRACE or 0)
	vim.notify(string.format("$%s = %s", "RUST_BACKTRACE", vim.env.RUST_BACKTRACE))
end
vim.api.nvim_create_user_command("RustToggleBackTrace", rust_toggle_back_trace, {})

---@return string|nil
local function get_nearest_test_name()
	local bufnr = 0
	local cursor = vim.api.nvim_win_get_cursor(0)
	local row, col = cursor[1] - 1, cursor[2]

	local root = vim.treesitter.get_parser(bufnr, "rust"):parse()[1]:root()
	local node = root:named_descendant_for_range(row, col, row, col)

	while node do
		if node:type() == "function_item" then
			local name_node = node:field("name")[1]
			if not name_node then
				return nil
			end

			local parent = node:parent()
			if parent then
				for child in parent:iter_children() do
					if child == node then
						break
					end
					if child:type() == "attribute_item" then
						local text = vim.treesitter.get_node_text(child, bufnr)
						if text:match("#%[test%]") then
							return vim.treesitter.get_node_text(name_node, bufnr)
						end
					end
				end
			end
		end

		node = node:parent()
	end

	return nil
end

local function nextest_current_test()
	local test_name = get_nearest_test_name()
	if not test_name then
		vim.notify("Cursor is not with in a test function", nil, { title = "Rust ftplugin" })
		return
	end

	local nextest_cmd = "cargo nextest run --no-capture -- --exact tests::" .. test_name
	-- Without sleep, echoed messsge is sometimes not displayed
	local cmd = "sleep 0.1 && echo '@@@ " .. nextest_cmd .. " @@@' && " .. nextest_cmd
	vim.cmd("tabnew | terminal " .. cmd)
end

require("keymap.which-key-helper").register_for_ftplugin({
	a = { rhs = "RustLsp codeAction", opts = { desc = "Code action" } },
	B = { rhs = "RustToggleBackTrace", opts = { desc = "Toggle RUST_BACKTRACE" } },
	c = { rhs = "RustLsp openCargo", opts = { desc = "Open Cargo.toml" } },
	d = { rhs = "RustLsp renderDiagnostic", opts = { desc = "Render diagnostics" } },
	e = { rhs = "RustLsp explainError", opts = { desc = "Explain error" } },
	g = { rhs = "RustLsp debuggables", opts = { desc = "Debug" } },
	G = { rhs = "RustLsp! debuggables", opts = { desc = "Rerun last debug" } },
	j = { rhs = "RustLsp moveItem down", opts = { desc = "Move item down" } },
	k = { rhs = "RustLsp moveItem up", opts = { desc = "Move item up" } },
	m = { rhs = "RustLsp expandMacro", opts = { desc = "Expand macro" } },
	M = { rhs = "RustLsp parentModule", opts = { desc = "Go to parent module" } },
	r = { rhs = "RustLsp runnables", opts = { desc = "Runnables" } },
	t = { rhs = "RustLsp testables", opts = { desc = "Testables" } },
	["<Space>t"] = { rhs = nextest_current_test, opts = { desc = "Nextest currnet func" } },
})
