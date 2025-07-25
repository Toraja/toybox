require("text.edit").map_toggle_trailing(";", ";", true)

local function rust_toggle_back_trace()
	vim.env.RUST_BACKTRACE = 1 - (vim.env.RUST_BACKTRACE or 0)
	vim.notify(string.format("$%s = %s", "RUST_BACKTRACE", vim.env.RUST_BACKTRACE))
end
vim.api.nvim_create_user_command("RustToggleBackTrace", rust_toggle_back_trace, {})

require("keymap.which-key-helper").register_for_ftplugin({
	a = { rhs = "RustLsp codeAction", opts = { desc = "Code action" } },
	B = { rhs = "RustToggleBackTrace", opts = { desc = "Toggle RUST_BACKTRACE" } },
	c = { rhs = "RustLsp openCargo", opts = { desc = "Open Cargo.toml" } },
	d = { rhs = "RustLsp renderDiagnostic", opts = { desc = "Render diagnostics" } },
	e = { rhs = "RustLsp explainError", opts = { desc = "Explain error" } },
	g = { rhs = "RustLsp debuggables", opts = { desc = "Debug" } },
	G = { rhs = "RustLsp! debuggables", opts = { desc = "Rerun last debug" } },
	j = { rhs = "RustLsp moveItem down", opts = { desc = "Move item down" } },
	k = { rhs = "RustLsp moveItem up", opts = { desc = "Move item up" } },
	m = { rhs = "RustLsp expandMacro", opts = { desc = "Expand macro" } },
	M = { rhs = "RustLsp parentModule", opts = { desc = "Go to parent module" } },
	r = { rhs = "RustLsp runnables", opts = { desc = "Runnables" } },
	t = { rhs = "RustLsp testables", opts = { desc = "Testables" } },
})
