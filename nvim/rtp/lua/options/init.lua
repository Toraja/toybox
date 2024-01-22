local M = {}

function M.setup(opts)
	opts = opts or {}

	-- system
	vim.opt.encoding = "utf-8"
	vim.opt.fileencodings:prepend("utf-8")
	vim.opt.shell = "/bin/bash"
	vim.opt.mouse = ""

	-- looks and feel
	vim.opt.background = "dark" -- color scheme for dark background
	vim.opt.number = true -- show line number
	-- vim.opt.relativenumber = true -- show distance relative to current line instead of absolute line number
	vim.opt.cursorline = true -- current line is underlined
	vim.opt.wrap = true -- whether to wrap long lines
	vim.opt.scrolloff = 5
	vim.opt.sidescrolloff = 1 -- offset between cursor and the edge of window"
	vim.opt.sidescroll = 1 -- scroll minimal when cursor goes off the screen horizontally
	vim.opt.laststatus = 3
	vim.opt.showtabline = 2 -- always display tabline
	vim.opt.shortmess:append("c")
	vim.opt.signcolumn = "yes"
	-- vim.opt.tabline = "%!v:lua.require('options.tabline').tabline()"

	-- editing
	vim.opt.tabstop = 4
	vim.opt.shiftwidth = 4
	vim.opt.expandtab = true -- use whitespaces instead of tab char
	vim.opt.autoindent = true
	vim.opt.smartindent = true
	vim.opt.shiftround = true -- round tab width for > and < command
	vim.opt.fileformats = "unix,dos,mac" -- Prefer Unix over Windows over OSX formats
	vim.opt.listchars = "tab:| " -- Show unvisible chars
	vim.opt.backspace = "indent,eol,start" -- Enable backspace to wrap line and delete break
	vim.opt.virtualedit = "block" -- Allow cursor to move beyond the EOL when visual-block mode
	vim.opt.iminsert = 0
	vim.opt.imsearch = -1 -- prevent entering Japaneve input mode when entering insert and search mode
	vim.opt.shellslash = true -- always use forward slash
	vim.opt.formatoptions:append("jmM")
	vim.opt.fixendofline = false -- Preserve the current EOL state
	vim.opt.timeoutlen = 600
	vim.opt.ttimeoutlen = 0 -- This prevents <Esc> to hang in input mode on Linux terminal

	-- search
	vim.opt.ignorecase = true -- Do case insensitive matching
	vim.opt.smartcase = true -- Do smart case matching
	vim.opt.incsearch = true -- Incremental search
	vim.opt.hlsearch = true -- highlight the match
	vim.opt.matchpairs:append("<:>") -- % command jumps between <> as well

	-- others
	vim.opt.swapfile = false
	vim.opt.cpoptions:append("Iy") -- I:autoindent is not removed when moving to other lines
	vim.opt.whichwrap:append("<,>") -- allow <Left> and <Right> in move to other lines
	vim.opt.complete:append("k") -- ins-completion option (include dictionary search)
	vim.opt.completeopt = { "longest", "menuone", "preview" } -- ins-completion mothod (complete to longest, display menu even though only one match)
	vim.opt.splitbelow = true -- splitted windows goes to below
	vim.opt.splitright = true -- splitted windows goes to right
	vim.opt.showcmd = true -- Show (partial) command in status line.
	vim.opt.lazyredraw = true -- screen will not be redrawn till macro execution is done
	vim.opt.diffopt:append("vertical")
	vim.opt.sessionoptions = { "blank", "curdir", "folds", "help", "tabpages", "winsize" }
	vim.opt.exrc = true

	-- command mode
	vim.opt.history = 1000
	vim.opt.wildignorecase = true -- command mode completion ignores case
	vim.opt.wildignore:append({ "*.swp", "*.bak", "*.class" }) -- ignore files this specified extentions on completion
	vim.opt.wildmenu = true -- display menu on command line completion
	vim.opt.wildcharm = 9 -- This enables cycling through popup version of wildmenu with <expr> keymap. 9 = <Tab>
	vim.opt.wildmode = { "full", "longest:full" } -- command mode completion method

	vim.api.nvim_create_user_command("SetFiletype", function(cmds)
		M.set_filetype(cmds.fargs[1])
	end, { nargs = "?", complete = "filetype" })

	vim.cmd("cnoreabbrev sf SetFiletype")
end

function M.signcolumn_toggle()
	if vim.wo.signcolumn == "no" then
		vim.wo.signcolumn = "yes"
		return
	end
	vim.wo.signcolumn = "no"
end

---@param filetype string?
function M.set_filetype(filetype)
	if filetype == nil then
		---@diagnostic disable-next-line: undefined-field
		filetype = vim.opt.filetype:get()
	end
	vim.opt.filetype = filetype
end

return M
