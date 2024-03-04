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
	dev = {
		---@type string | fun(plugin: LazyPlugin): string directory where you store your local plugin projects
		path = "~/workspace/personal.github.com/Toraja",
		---@type string[] plugins that match these patterns will use your local versions instead of being fetched from GitHub
		patterns = { "Toraja" },
		fallback = false, -- Fallback to git when local plugin doesn't exist
	},
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

require("options.tabline").setup() -- this depends on nvim-web-devicons
require("ft-common").setup() -- this depends on which-key
