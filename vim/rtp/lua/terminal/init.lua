vim.api.nvim_create_user_command("TabnewTerminalMulti", function(cmds)
	for _, name in ipairs(cmds.fargs) do
		vim.cmd("tabnew | terminal fish")
		vim.cmd("file " .. name)
	end
end, { nargs = "+" })
