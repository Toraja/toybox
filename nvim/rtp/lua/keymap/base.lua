-- This module is for basic keymap and cannot depend on any plugin.
local M = {}

---@param lh string
---@param rh any
---@param opts table
local function map_with_underscore(lh, rh, opts)
	vim.keymap.set("n", "_" .. lh, rh, opts)
end

function M.setup(opts)
	opts = opts or {}

	vim.g.mapleader = " "
	vim.g.maplocalleader = "-"
	vim.keymap.set({ "n", "x", "o" }, "<Space>", "")
	vim.g.vert_key = "<C-Space>"
	vim.g.chief_key = ";"

	-- motion
	vim.keymap.set({ "n", "x" }, "j", "gj")
	vim.keymap.set({ "n", "x" }, "k", "gk")
	vim.keymap.set("o", "j", "Vj")
	vim.keymap.set("o", "k", "Vk")
	vim.keymap.set("x", "J", "j") -- prevent accidental line join
	vim.keymap.set("x", "K", "k") -- prevent accidentally opening help
	vim.keymap.set({ "n", "x", "o" }, "H", "^")
	vim.keymap.set({ "n", "o" }, "L", "$")
	vim.keymap.set("x", "L", "g_")

	vim.keymap.set("s", "<C-b>", "<Left>")
	vim.keymap.set("s", "<C-f>", "<Right>")
	vim.keymap.set("s", "<M-f>", "<S-Right>")
	vim.keymap.set("s", "<M-b>", "<S-Left>")
	vim.keymap.set("s", "<C-p>", "<Up>")
	vim.keymap.set("s", "<C-n>", "<Down>")
	vim.keymap.set("s", "<C-i>", "<ESC>i")

	---- insert/command mode
	vim.keymap.set("i", "<C-b>", "<Left>")
	vim.keymap.set("i", "<C-f>", "<Right>")
	vim.keymap.set("i", "<M-b>", "<C-Left>")
	vim.keymap.set("i", "<M-f>", "<C-Right>")
	vim.keymap.set("i", "<M-e>", "<Esc>ea")
	vim.keymap.set("i", "<M-E>", "<Esc>Ea")
	vim.keymap.set("i", "<C-a>", "<C-o>^")
	vim.keymap.set("i", "<C-e>", "<End>")
	vim.keymap.set("i", "<C-p>", "<Up>")
	vim.keymap.set("i", "<C-n>", "<Down>")

	-- scrolling
	vim.keymap.set({ "n", "x", "s" }, "<C-u>", "10<C-y>")
	vim.keymap.set({ "n", "x", "s" }, "<C-d>", "10<C-e>")
	vim.keymap.set({ "n", "x", "s" }, "<M-y>", "zh")
	vim.keymap.set({ "n", "x", "s" }, "<M-e>", "zl")
	vim.keymap.set({ "n", "x", "s" }, "<M-Y>", "zH")
	vim.keymap.set({ "n", "x", "s" }, "<M-E>", "zL")

	-- editing
	vim.keymap.set("n", "<M-x>", '"_x')
	vim.keymap.set("n", "<M-X>", '"_X')
	vim.keymap.set("s", "<C-h>", "<Space><BS>")
	---- insert/command mode
	vim.keymap.set("!", "<C-Space>", "<Space><Left>")
	vim.keymap.set("i", "<C-w>", "<C-g>u<C-w>")
	vim.keymap.set("i", "<C-u>", "<C-g>u<C-u>")
	vim.keymap.set("i", "<C-y>", '<C-g>u<C-r>"')
	vim.keymap.set("c", "<C-y>", '<C-r>"')
	vim.keymap.set("!", "<M-y>", "<C-r>*")
	vim.keymap.set("i", "<C-d>", "<DEL>")
	vim.keymap.set("i", "<M-d>", '<C-g>u<C-\\><C-o>"_dw')
	vim.keymap.set("i", "<C-k>", '<C-g>u<C-\\><C-o>"_D')
	vim.keymap.set("i", "<M-h>", "<C-g>u<C-w>")
	vim.keymap.set("c", "<M-h>", "<C-w>")
	vim.keymap.set("i", "<M-t>", "<C-d>")
	vim.keymap.set("i", "<C-j>", "<CR><Esc><Up>A")
	---- UPPER/lowercase & Capitalize
	vim.keymap.set("i", "<M-u>", "<Esc>gUiwea")
	vim.keymap.set("i", "<M-l>", "<Esc>guiwea")
	vim.keymap.set("i", "<M-c>", "<Esc>guiwgU<right>ea")
	---- line break/join
	vim.keymap.set("n", "<M-m>", "mpo<Esc>0Dg`p|") -- insert blank line below
	vim.keymap.set("n", "<M-M>", "mpO<Esc>0Dg`p|") -- insert blank line above
	vim.keymap.set("n", "<M-o>", "o<Esc>")
	vim.keymap.set("n", "<M-O>", "O<Esc>")
	vim.keymap.set("n", "<C-j>", "i<CR><Esc><Up><End>")
	---- other editing
	vim.keymap.set("x", "y", "ygv<Esc>") -- retain the cursor position where it is (by default, cursor moves to the beginning of selection)
	vim.keymap.set("n", "Y", "y$")
	vim.keymap.set("n", "yx", "yVaB%p")
	vim.keymap.set("x", "<C-a>", "<C-a>gv", { silent = true })
	vim.keymap.set("x", "<C-x>", "<C-x>gv", { silent = true })
	vim.keymap.set("n", "g<C-a>", ":call search('[0-9]', 'be', line('.'))<CR><C-a>", { silent = true })
	vim.keymap.set("n", "g<C-x>", ":call search('[0-9]', 'be', line('.'))<CR><C-x>", { silent = true })
	vim.keymap.set("n", "d.", '/\\s\\+$<CR>"_dgn|') -- delete trailing spaces
	vim.keymap.set("n", "U", "")
	vim.keymap.set("i", "<C-_>", "<C-o>u")
	vim.keymap.set("i", "<C-/>", "<C-o>u")
	vim.keymap.set("i", "<M-/>", "<C-o><C-r>")
	-- set undo break before commands below
	vim.keymap.set("i", "<Space>", "<C-g>u<Space>")
	vim.keymap.set("i", "<C-m>", "<C-g>u<C-m>")
	vim.keymap.set("i", ".", ".<C-g>u")

	-- search
	vim.keymap.set("n", "n", "nzx") -- `zx` opens fold which the match belongs to so that you can view where exactly the match is.
	vim.keymap.set("n", "N", "Nzx")
	vim.keymap.set("n", "<M-u>", function()
		if vim.o.hlsearch and vim.v.hlsearch == 1 then
			vim.cmd("nohlsearch")
			return
		end
		vim.o.hlsearch = true
	end, { silent = true })
	vim.keymap.set({ "n", "x" }, "*", function()
		require("search").highlight_word()
	end, { silent = true })
	vim.keymap.set({ "n", "x" }, "g*", function()
		require("search").highlight_word({ exclusive = true })
	end, { silent = true })

	-- window
	vim.keymap.set("n", "<C-w>O", "<Cmd>only!<CR>", { silent = true })
	vim.keymap.set("n", "<C-w>B", function()
		vim.api.nvim_buf_delete(0)
	end, { desc = "Delete current buffer" })

	-- tab
	vim.keymap.set("n", "<C-t>", "<Nop>")
	vim.keymap.set("n", "<C-t><C-d>", "<Cmd>tab split<CR>", { silent = true, desc = "Duplicate tab" })
	vim.keymap.set("n", "<C-t><C-f>", "<C-w>gf", { desc = "gf in tab" })
	vim.keymap.set("n", "<C-t><C-n>", "<Cmd>tabnew<CR>", { silent = true })
	vim.keymap.set("n", "<C-t><C-o>", "<Cmd>tabonly<CR>", { silent = true })
	vim.keymap.set("n", "<C-t><C-q>", function()
		if vim.v.count == 0 then
			vim.cmd("tabclose")
			return
		end

		---@diagnostic disable-next-line: param-type-mismatch
		ok, result = pcall(vim.cmd, vim.v.count .. "tabclose")
		if not ok then
			---@diagnostic disable-next-line: param-type-mismatch
			vim.notify(result, vim.log.levels.WARN, { title = "tabclose" })
		end
	end, { desc = "tabclose" })
	vim.keymap.set("n", "<C-t><CR>", "<C-w><CR><C-w>T", { desc = "Open quickfix entry in tab" })
	vim.keymap.set("n", "<C-l>", "gt")
	vim.keymap.set("n", "<C-h>", "gT")
	vim.keymap.set("n", "<M-l>", "<Cmd>tabmove+<CR>")
	vim.keymap.set("n", "<M-h>", "<Cmd>tabmove-<CR>")
	for n = 1, 9 do
		vim.keymap.set("n", "<M-" .. n .. ">", n .. "gt")
	end
	vim.keymap.set("n", "<M-0>", "10gt")
	vim.keymap.set("n", "<C-t><C-t>", require("tab").focus_last_tab, { silent = true, desc = "Focus last tab" })

	-- close/exit
	vim.keymap.set("n", "ZB", function()
		vim.api.nvim_buf_delete(0, { force = true })
	end)
	vim.keymap.set("n", "ZT", "<Cmd>windo quit!<CR>")
	vim.keymap.set("n", "<C-w><C-a>", "<Cmd>windo confirm quit<CR>")
	vim.keymap.set("n", "<C-w>A", "<Cmd>confirm qall<CR>")

	-- others
	vim.keymap.set("", "<S-Space>", "<Space>", { remap = true })
	vim.keymap.set("n", "<C-s>", "<Cmd>update ++p<CR>") -- ++p creates parent dirs if absent
	vim.keymap.set("n", "Q", "gQ")
	vim.keymap.set("n", "<M-c>", "<Cmd>mode<CR>")

	vim.keymap.set("c", "<M-p>", "<Up>")
	vim.keymap.set("c", "<M-n>", "<Down>")
	vim.keymap.set("c", "<M-@>", "<Home>let @\" = '<End>'")

	vim.keymap.set("i", "<C-x><C-q>", "<C-o>gql<End>")
	vim.keymap.set("!", "<C-q><C-b>", "expand('%:t')", { desc = "Buffer's basename", expr = true })
	vim.keymap.set("!", "<C-q><C-s>", "expand('%:t:r')", { desc = "Buffer's simple name", expr = true })
	vim.keymap.set("!", "<C-q><C-d>", "expand('%:p:~:h')", { desc = "Buffer's directory", expr = true })
	vim.keymap.set("!", "<C-q><C-f>", "expand('%:p:~')", { desc = "Buffer's absolute path", expr = true })
	vim.keymap.set("!", "<C-q><C-p>", "getcwd()", { desc = "cwd", expr = true })
	vim.keymap.set("!", "<C-q><C-o>", require("git").root_path, { desc = "Git root path", expr = true })

	map_with_underscore(
		"c",
		"<Cmd>lcd %:p:h | echo 'lcd -> ' . expand('%:p:~:h')<CR>",
		{ desc = "lcd to buffer's dir" }
	)
	map_with_underscore("w", "<Cmd>set wrap!<CR>", { desc = "Toggle wrap" })
	map_with_underscore("-", "<Cmd>lcd ..<CR>", { desc = "lcd to parent dir" })
	map_with_underscore("<Space>", function()
		vim.wo.number = not vim.wo.number
		require("options").signcolumn_toggle()
	end, { desc = "Toggle left spaces" })
end

return M
