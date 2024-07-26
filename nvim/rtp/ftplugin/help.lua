vim.keymap.set("n", "<C-]>", "<C-]>", { buffer = true, desc = "Help" }) -- <C-]> is mapped to LSP stuff so remap to default
vim.keymap.set("n", "<C-w><C-]>", "<C-w>g<C-]>", { buffer = true, desc = "Help [horz]" })
vim.keymap.set("n", vim.g.vert_key .. "<C-]>", "<C-w><C-v>g<C-]>", { buffer = true, desc = "Help [vert]" })
vim.keymap.set("n", "<C-t><C-]>", "<C-w><C-v>g<C-]><C-w>T", { buffer = true, desc = "Help [tab]" })
