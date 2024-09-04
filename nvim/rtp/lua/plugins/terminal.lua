local yazi_chooser_file = "/tmp/yazi_chooser"
local key_direction_map = {
	e = { command = "edit", display = "current buffer" },
	x = { command = "new", display = "horizontal window" },
	v = { command = "vertical new", display = "vertical window" },
	t = { command = "tabedit", display = "tab" },
}

function get_buf_open_command()
	-- popup must be created every time or the window will not be displayed after a few times
	local popup = require("nui.popup")({
		enter = false,
		focusable = true,
		border = {
			style = "rounded",
			padding = {
				left = 1,
				right = 1,
			},
			text = {
				top = " Open file in ",
			},
		},
		position = {
			row = "40%",
			col = "50%",
		},
		size = {
			width = "20",
			height = "4",
		},
		zindex = 1000,
	})

	popup:mount()
	vim.api.nvim_buf_set_lines(
		popup.bufnr,
		0,
		1,
		false,
		{ "t: tab", "v: vertical window", "x: horizontal window", "e: current buffer" }
	)
	vim.cmd("redraw")

	local direction
	while true do
		local c = vim.fn.getcharstr()
		if c == "" or c == "" then
			popup:unmount()
			os.remove(yazi_chooser_file)
			return
		end

		direction = key_direction_map[c]
		if direction ~= nil then
			break
		end

		-- FIXME: notification is hidden until the next one comes in
		vim.notify("Invalid key: " .. c, vim.log.levels.WARN)
	end

	popup:unmount()
	---@diagnostic disable-next-line: need-check-nil, undefined-field
	return direction.command
end

return {
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		dependencies = {
			"MunifTanjim/nui.nvim",
		},
		config = function()
			local shell = "fish"
			require("toggleterm").setup({
				open_mapping = [[<M-\>]],
				on_create = function()
					vim.opt_local.signcolumn = "no"
				end,
				on_open = function(term)
					if not term:is_float() then
						-- NOTE: setting tab variable has to be in `on_open`  instead of `on_create`
						-- or tab variable will disappear when toggleterm is reopened.
						require("tab").set_tab_name(0, vim.split(term.name, ";#")[2])
					end
					vim.cmd([[
								startinsert
								]])
				end,
				-- Do not set autochdir to `true` as it is dangerous.
				-- The way toggleterm changes directory is inserting `cd /dir/to/change<CR>` to command line
				-- so if command line buffer is not empty, not only changing directory fails, but also a command
				-- is executed unexpectedly.
				autochdir = false,
				direction = "tab",
				shell = shell,
			})
		end,
		keys = {
			{ "<M-Bslash>", "<M-Bslash>", mode = { "n" }, desc = "Toggle Terminal" },
			{
				"<Leader>v",
				function()
					-- Terminal:new() must be called everytime, or the cwd is not updated
					-- and the cwd at which vim is started is used instead.
					require("toggleterm.terminal").Terminal
						:new({
							cmd = "lazygit",
							direction = "float",
							float_opts = {
								width = math.floor(vim.o.columns * 0.95),
								height = math.floor(vim.o.lines - 6),
							},
						})
						:toggle()
				end,
				mode = { "n" },
				desc = "lazygit",
			},
			{
				"<Leader>e",
				function()
					require("toggleterm.terminal").Terminal
						:new({
							cmd = string.format(
								"yazi --chooser-file '%s' %s",
								yazi_chooser_file,
								vim.api.nvim_buf_get_name(0) == "" and "" or string.format("'%s'", vim.fn.expand("%:p"))
							),
							direction = "float",
							float_opts = {
								width = math.floor(vim.o.columns * 0.95),
								height = math.floor(vim.o.lines - 6),
							},
							on_exit = function(_, _, _, _)
								-- By force closing window before displaying popup, `edit` command will work,
								-- but if windows are vertically split, popup is displayed at the centre of focused window.
								-- (not the centre of entire screen)
								-- require("toggleterm.ui").close(term)

								local yazi_chooser_file_stat = vim.uv.fs_stat(yazi_chooser_file)
								if yazi_chooser_file_stat == nil then
									return
								end
								if yazi_chooser_file_stat.type ~= "file" then
									vim.notify(
										string.format("yazi chooser file %s is not a file", yazi_chooser_file),
										vim.log.levels.WARN
									)
								end
								local chosen_file = vim.fn.readfile(yazi_chooser_file)[1]
								if not chosen_file then
									vim.notify(
										"Could not get the choosen file",
										vim.log.levels.WARN,
										{ title = "yazi" }
									)
									os.remove(yazi_chooser_file)
									return
								end

								local cmd = get_buf_open_command()
								if cmd == nil then
									return
								end

								vim.cmd(string.format("%s %s", cmd, chosen_file))
								os.remove(yazi_chooser_file)
							end,
						})
						:toggle()
				end,
				mode = { "n" },
				desc = "yazi",
			},
		},
	},
	{
		"ryanmsnyder/toggleterm-manager.nvim",
		enabled = false,
		dependencies = {
			"akinsho/toggleterm.nvim",
			"nvim-telescope/telescope.nvim",
		},
		config = function()
			local toggleterm_manager = require("toggleterm-manager")
			local actions = toggleterm_manager.actions
			toggleterm_manager.setup({
				mappings = {
					i = {
						["<CR>"] = { action = actions.open_term, exit_on_action = true },
						["<C-i>"] = { action = actions.create_and_name_term, exit_on_action = false },
						["<C-o>"] = { action = actions.create_term, exit_on_action = false },
						["<C-Space>"] = { action = actions.toggle_term, exit_on_action = false },
					},
				},
			})
		end,
	},
	{
		"willothy/flatten.nvim",
		-- Commands that open editor (such as git rebase -i) do not work properly as when flatten.nvim opens vim in outer instance,
		-- those command detect editor being closed without any edit and move to next step.
		enabled = false,
		opts = {
			window = {
				open = "tab",
			},
		},
	},
}
