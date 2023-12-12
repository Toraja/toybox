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
		vim.api.nvim_err_writeln("Clipboard is not available")
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

function M.setup(opts)
	opts = opts or {}

	vim.api.nvim_create_user_command("NamedRegistersClear", M.named_registers_clear, {})

	vim.keymap.set("n", vim.g.chief_key .. vim.g.chief_key, clip_func)

	vim.keymap.set("n", "yp", function()
		local current_file_path = vim.fn.expand("%:p:~")
		vim.fn.setreg('"', current_file_path)
		if clipboard_char ~= "" then
			vim.fn.setreg(clipboard_char, current_file_path)
			print("Clipped:", current_file_path)
		else
			print("Yanked:", current_file_path)
		end
	end)
end

return M
