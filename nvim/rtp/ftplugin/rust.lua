require("text.edit").map_toggle_trailing(";", ";", true)

local function rust_toggle_back_trace()
	vim.env.RUST_BACKTRACE = 1 - (vim.env.RUST_BACKTRACE or 0)
	vim.notify(string.format("$%s = %s", "RUST_BACKTRACE", vim.env.RUST_BACKTRACE))
end
vim.api.nvim_create_user_command("RustToggleBackTrace", rust_toggle_back_trace, {})

require("keymap.which-key-helper").register_for_ftplugin({
	a = { "RustLsp codeAction", { desc = "Code action" } },
	B = { "RustToggleBackTrace", { desc = "Toggle RUST_BACKTRACE" } },
	c = { "RustLsp openCargo", { desc = "Open Cargo.toml" } },
	d = { "RustLsp renderDiagnostic", { desc = "Render diagnostics" } },
	e = { "RustLsp explainError", { desc = "Explain error" } },
	g = { "RustLsp debuggables", { desc = "Debug" } },
	G = { "RustLsp! debuggables", { desc = "Rerun last debug" } },
	j = { "RustLsp moveItem down", { desc = "Move item down" } },
	k = { "RustLsp moveItem up", { desc = "Move item up" } },
	m = { "RustLsp expandMacro", { desc = "Expand macro" } },
	M = { "RustLsp parentModule", { desc = "Go to parent module" } },
	r = { "RustLsp runnables", { desc = "Runnables" } },
	t = { "RustLsp testables", { desc = "Testables" } },
})
