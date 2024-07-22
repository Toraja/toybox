require("text.edit").map_toggle_trailing(";", ";", true)

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
