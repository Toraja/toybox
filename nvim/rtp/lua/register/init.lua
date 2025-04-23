local M = {}

local function get_clipboard_char()
	if vim.fn.has("xterm_clipboard") then
		return "+"
	end
	if vim.fn.has("clipboard") then
		return "*"
	end
	return ""
end
local clipboard_char = get_clipboard_char()

local clip_func
if clipboard_char == "" then
	clip_func = function()
		vim.api.nvim_echo({ { "Clipboard is not available" } }, true, { err = true })
	end
else
	clip_func = function()
		vim.fn.setreg(clipboard_char, vim.fn.getreg('"'))
		print("Clipped yanked text")
	end
end

function M.named_registers_clear()
	local ascii_code_a, ascii_code_z = string.byte("a"), string.byte("z")
	for i = ascii_code_a, ascii_code_z do
		vim.fn.setreg(string.char(i), {})
	end
	-- Make the changes to registers permanent by running the command below,
	-- or the registers will come back alive on the next launch of nvim
	vim.cmd("wshada!")
	print("All named registers have been cleared")
end

---@param s string
function M.yank_or_clip(s)
	vim.fn.setreg('"', s)
	if clipboard_char ~= "" then
		vim.fn.setreg(clipboard_char, s)
		print("Clipped:", s)
	else
		print("Yanked:", s)
	end
end

function M.setup(opts)
	opts = opts or {}

	vim.api.nvim_create_user_command("NamedRegistersClear", M.named_registers_clear, {})

	vim.keymap.set({ "n", "x" }, "+", '"' .. clipboard_char)
	vim.keymap.set("n", "++", clip_func)
	vim.keymap.set({ "n", "x" }, "_", '"_')

	vim.keymap.set("n", "ypf", function()
		M.yank_or_clip(vim.fn.expand("%:p:~"))
	end, { desc = "Yank buffer's full path" })
	vim.keymap.set("n", "ypd", function()
		M.yank_or_clip(vim.fn.expand("%:p:~:h"))
	end, { desc = "Yank buffer's directory path" })
	vim.keymap.set("n", "ypb", function()
		M.yank_or_clip(vim.fn.expand("%:t"))
	end, { desc = "Yank buffer's basename" })
	vim.keymap.set("n", "yps", function()
		M.yank_or_clip(vim.fn.expand("%:t:r"))
	end, { desc = "Yank buffer's simple name" })
	vim.keymap.set("n", "ypc", function()
		M.yank_or_clip(vim.fn.expand("%:t:r"))
	end, { desc = "Yank cwd" })
	vim.keymap.set("n", "ypo", function()
		M.yank_or_clip(require("git").root_path())
	end, { desc = "Yank git root path" })
end

return M
