-- disable netrw so that netrw does not flicker when opening directory
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local rtp_dir = vim.fn.expand("<sfile>:p:h") .. "/rtp"
vim.opt.rtp:prepend(rtp_dir)

require("options")
require("keymap.base").setup()
require("terminal").setup()
require("register").setup()
require("text.edit").map_toggle_trailing(",", ",")
require("qf").setup()

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

local after_dir = rtp_dir .. "/after"
local snippets_dir = rtp_dir .. "/snippets"

require("lazy").setup("plugins", {
	ui = {
		-- The border to use for the UI window. Accepts same border values as |nvim_open_win()|.
		border = "rounded",
		icons = {
			lazy = "  ", -- replace default devicon as it breaks border
		},
	},
	change_detection = {
		-- automatically check for config file changes and reload the ui
		notify = false, -- get a notification when changes are found
	},
	performance = {
		rtp = {
			-- lazy nicely appends `after` directory to runtimepath after all plugins are added.
			paths = { rtp_dir, snippets_dir, after_dir },
		},
	},
})

local wk = require("which-key")

require("options.tabline").setup() -- this depends on nvim-web-devicons
require("ft-common").setup() -- this depends on which-key

-- highlight
-- vim.api.nvim_set_hl(0, 'String', { ctermfg = 216 })
-- vim.api.nvim_set_hl(0, 'Comment', { ctermfg = 246 })
-- vim.api.nvim_set_hl(0, 'Folded', { ctermfg = 246, fg = '#41535b' })
-- vim.api.nvim_set_hl(0, 'PmenuSel', { ctermfg = 254, ctermbg = 240, bold = true, bg = 'Blue' })
-- vim.api.nvim_set_hl(0, 'Pmenu', { ctermfg = 254, ctermbg = 236, bg = 'DarkGrey' })
-- vim.api.nvim_set_hl(0, 'ColorColumn', { ctermbg = 6, bg = 'DarkCyan' })

local highlight_augroud_id = vim.api.nvim_create_augroup("custom_highlight", {})
vim.api.nvim_create_autocmd({ "BufWinEnter", "InsertEnter", "InsertLeave" }, {
	group = highlight_augroud_id,
	desc = "Highlight trailing whitespaces and mixture of space and tab",
	pattern = "*",
	callback = function()
		local excluded_filetypes = { "help", "toggleterm", "neo-tree" }
		if vim.tbl_contains(excluded_filetypes, vim.opt.filetype:get()) then
			return
		end
		vim.cmd([[syntax match AnnoyingSpaces "\s\+$\| \+\t\+\|\t\+ \+"]])
	end,
})

function signcolumn_toggle()
	if vim.wo.signcolumn == "no" then
		vim.wo.signcolumn = "yes"
		return
	end
	vim.wo.signcolumn = "no"
end

wk.register({
	["_"] = {
		name = "nice ones",
		c = { "<Cmd>lcd %:p:h | echo 'lcd -> ' . expand('%:p:~:h')<CR>", "lcd to the file's dir" },
		w = { "<Cmd>set wrap!<CR>", "Toggle wrap" },
		["<Space>"] = { "<Cmd>lua vim.wo.number = not vim.wo.number; signcolumn_toggle()<CR>", "Toggle left spaces" },
	},
})

vim.keymap.set("i", "<C-x><C-q>", "<C-o>gql<End>")
vim.keymap.set("!", "<C-q><C-b>", "expand('%:t')", { desc = "Buffer's basename", expr = true })
vim.keymap.set("!", "<C-q><C-s>", "expand('%:t:r')", { desc = "Buffer's simple name", expr = true })
vim.keymap.set("!", "<C-q><C-d>", "expand('%:p:~:h')", { desc = "Buffer's directory", expr = true })
vim.keymap.set("!", "<C-q><C-f>", "expand('%:p:~')", { desc = "Buffer's absolute path", expr = true })
vim.keymap.set("!", "<C-q><C-p>", "getcwd()", { desc = "cwd", expr = true })
vim.keymap.set("!", "<C-q><C-o>", require("git").root_path, { desc = "Git root path", expr = true })

vim.cmd("cnoreabbrev tn tabnew")
vim.cmd("cnoreabbrev th tab help")

function delete_hidden_buffers()
	local function delete_buffer_if_hidden(buf)
		if buf.hidden == 1 then
			vim.api.nvim_buf_delete(buf.bufnr, {})
		end
	end
	local buffers = vim.fn.getbufinfo({ buflisted = true, bufloaded = true })
	vim.tbl_map(delete_buffer_if_hidden, buffers)
end

vim.api.nvim_create_user_command("DeleteHiddenBuffers", delete_hidden_buffers, {})

wk.register({
	["<F3>"] = {
		name = "Source rc file",
		["<F3>"] = { "<Cmd>source $MYVIMRC<CR>", "Reload $MYVIMRC" },
		g = { "<Cmd>source $MYGVIMRC<CR>", "Reload $MYGVIMRC" },
		f = { "<Cmd>SetFt<CR>", "Reload ftplugin" },
		i = { "require('lazy').install()", "Install missing plugins" },
		s = { "require('lazy').sync()", "Sync plugins" },
		o = {
			name = "Open",
			v = { "<Cmd>tabnew $MYVIMRC<CR>", "Open $MYVIMRC" },
			f = { "<Cmd>call OpenFtplugins(&ft)<CR>", "Open ftplugins" },
		},
	},
})

function preserve_cursor(func)
	local current_win = vim.api.nvim_get_current_win()
	local cursor_position = vim.api.nvim_win_get_cursor(0)
	func()
	vim.api.nvim_set_current_win(current_win)
	vim.api.nvim_win_set_cursor(current_win, cursor_position)
end
