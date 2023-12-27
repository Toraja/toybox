-- disable netrw so that netrw does not flicker when opening directory
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local rtp_dir = vim.fn.expand("<sfile>:p:h") .. "/rtp"
vim.opt.rtp:prepend(rtp_dir)

require("options").setup()
require("keymap.base").setup()
require("appearance").setup()
require("buffer").setup()
require("tab").setup()
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

vim.cmd("cnoreabbrev tn tabnew")
vim.cmd("cnoreabbrev th tab help")

wk.register({
	["_"] = {
		name = "nice ones",
		c = { "<Cmd>lcd %:p:h | echo 'lcd -> ' . expand('%:p:~:h')<CR>", "lcd to the file's dir" },
		w = { "<Cmd>set wrap!<CR>", "Toggle wrap" },
		["<Space>"] = {
			function()
				vim.wo.number = not vim.wo.number
				require("options").signcolumn_toggle()
			end,
			"Toggle left spaces",
		},
		["-"] = { "<Cmd>lcd ..<CR>", "lcd to parent dir" },
	},
})

wk.register({
	["<F3>"] = {
		name = "Source rc file",
		["<F3>"] = { "<Cmd>source $MYVIMRC<CR>", "Reload $MYVIMRC" },
		g = { "<Cmd>source $MYGVIMRC<CR>", "Reload $MYGVIMRC" },
		f = { "<Cmd>SetFiletype<CR>", "Reload ftplugin" },
		i = { "require('lazy').install()", "Install missing plugins" },
		s = { "require('lazy').sync()", "Sync plugins" },
	},
})
