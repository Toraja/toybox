vim.opt_local.shiftwidth = 2
vim.opt_local.tabstop = 2
vim.opt_local.conceallevel = 0
vim.opt_local.foldmethod = "marker"
vim.opt_local.formatoptions:append("ro")
-- Quoted from :help format-comments
-- > When one comment leader is part of another, specify the part after the whole.
vim.opt_local.comments = { "b:* [ ]", "b:- [ ]", "b:+ [ ]", "b:1. [ ]", "b:*", "b:-", "b:+", "b:1.", "n:>" }

require("text.edit").map_toggle_trailing(";", "  ", true)

local ts = vim.treesitter
local parsers = require("nvim-treesitter.parsers")

local checkbox_ptn = "^([ \t]*)(- %[)(.)(%] )"
local checkbox_line_ptn = checkbox_ptn .. "(.*)"
local checkbox_markers = {
	undone = " ",
	done = "X",
	in_progress = "/",
	cancelled = "~",
	on_hold = "=",
}

local function is_todo_line(line)
	return string.match(line, checkbox_line_ptn) ~= nil
end

local function replace_checkbox_state(line, state)
	if not is_todo_line(line) then
		print("not todo line")
		return
	end

	-- wrapping in parentheses returns only the first value
	return (string.gsub(line, checkbox_line_ptn, "%1%2" .. state .. "%4%5", 1))
end

vim.api.nvim_buf_create_user_command(0, "MarkdownCheckboxStateSet", function(command)
	local marker = checkbox_markers[command.fargs[1]]
	if not marker then
		error("invalid checkbox state: " .. command.fargs[1])
	end
	vim.api.nvim_set_current_line(replace_checkbox_state(vim.api.nvim_get_current_line(), marker))
end, { nargs = 1 })

local function conceal_toggle()
	vim.wo.conceallevel = vim.wo.conceallevel == 0 and 2 or 0
end

vim.api.nvim_buf_create_user_command(0, "ConcealToggle", function()
	conceal_toggle()
end, {})

-- Text object: select the URL of the markdown link under cursor.
-- Handles both inline links [text](url) and images ![alt](url).
local function select_link_url()
	local cursor = vim.api.nvim_win_get_cursor(0)
	local row = cursor[1] - 1 -- 0-indexed
	local col = cursor[2]

	-- ts.get_node({ lang = "markdown_inline" }) does not work for injected trees.
	-- Obtain the markdown_inline child parser directly and resolve the deepest
	-- named node with named_descendant_for_range() instead.
	local parser = ts.get_parser(0)
	parser:parse()

	local inline_parser = parser:children()["markdown_inline"]
	if not inline_parser then
		vim.notify("markdown_inline parser not available", vim.log.levels.WARN)
		return
	end

	for _, tree in ipairs(inline_parser:trees()) do
		local root = tree:root()
		local node = root:named_descendant_for_range(row, col, row, col)
		if not node then
			goto continue
		end

		-- Walk up to the enclosing inline_link or image node.
		local current = node
		while current do
			local t = current:type()
			if t == "inline_link" or t == "image" then
				break
			end
			current = current:parent()
		end

		if current then
			for child in current:iter_children() do
				if child:type() == "link_destination" then
					local start_row, start_col, end_row, end_col = child:range() -- ec is exclusive
					-- 'v' toggles visual mode, so if already in visual mode it would
					-- exit instead of re-entering. Escape first to reach normal mode.
					local mode = vim.api.nvim_get_mode().mode
					local ctrl_v = vim.api.nvim_replace_termcodes("<C-v>", true, false, true)
					if mode == "v" or mode == "V" or mode == ctrl_v then
						vim.api.nvim_feedkeys(
							vim.api.nvim_replace_termcodes("<Esc>", true, false, true),
							"x", -- execute immediately (synchronous)
							false
						)
					end
					vim.api.nvim_win_set_cursor(0, { start_row + 1, start_col })
					vim.cmd("normal! v")
					vim.api.nvim_win_set_cursor(0, { end_row + 1, end_col - 1 })
					return
				end
			end
		end

		::continue::
	end

	vim.notify("Cursor is not on a markdown link", vim.log.levels.WARN)
end

-- Map as a text object in operator-pending and visual modes.
vim.keymap.set({ "o", "x" }, "iu", select_link_url, { buffer = true, desc = "URL in markdown link" })

local todo_prefix_key = "t"
local todo_priority_prefix_key = todo_prefix_key .. "r"
require("keymap.which-key-helper").register_for_ftplugin({
	C = { rhs = "ConcealToggle", opts = { desc = "Toggle conceallevel between 0 and 2" } },
	[todo_prefix_key .. "c"] = {
		rhs = 'lua require("checkmate").toggle("cancelled"); require("checkmate").remove_metadata("done")',
		opts = { desc = "TODO cancelled" },
	},
	[todo_prefix_key .. "d"] = {
		rhs = 'lua require("checkmate").toggle_metadata("done")',
		opts = { desc = "TODO done" },
	},
	[todo_prefix_key .. "h"] = {
		rhs = 'lua require("checkmate").toggle("on_hold"); require("checkmate").remove_metadata("done")',
		opts = { desc = "TODO on hold" },
	},
	[todo_prefix_key .. "p"] = {
		rhs = 'lua require("checkmate").toggle("in_progress"); require("checkmate").remove_metadata("done")',
		opts = { desc = "TODO in progress" },
	},
	[todo_priority_prefix_key .. "h"] = {
		rhs = 'lua require("checkmate").add_metadata("priority", "high")',
		opts = { desc = "TODO priority high" },
	},
	[todo_priority_prefix_key .. "l"] = {
		rhs = 'lua require("checkmate").add_metadata("priority", "low")',
		opts = { desc = "TODO priority low" },
	},
	[todo_priority_prefix_key .. "m"] = {
		rhs = 'lua require("checkmate").add_metadata("priority", "medium")',
		opts = { desc = "TODO priority medium" },
	},
	[todo_priority_prefix_key .. "r"] = {
		rhs = 'lua require("checkmate").remove_metadata("priority")',
		opts = { desc = "TODO priority high" },
	},
	[todo_prefix_key .. "s"] = {
		rhs = 'lua require("checkmate").toggle_metadata("started")',
		opts = { desc = "TODO started" },
	},
	[todo_prefix_key .. "u"] = {
		rhs = 'lua require("checkmate").toggle("unchecked"); require("checkmate").remove_metadata("done")',
		opts = { desc = "TODO undone" },
	},
	v = { rhs = "Markview Toggle", opts = { desc = "Toggle Markview" } },
})
