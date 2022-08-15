local wk = require("which-key")
wk.register({
  ["<C-]>"] = { "<C-]>", "Help" },
  ["<C-w><C-]>"] = { "<C-w>g<C-]>", "Help [horz]" },
  ["[Vert]<C-]>"] = { "<C-w><C-v>g<C-]>", "Help [vert]" },
  ["<C-t><C-]>"] = { "<C-w><C-v>g<C-]><C-w>T", "Help [tab]" },
}, { buffer = 0 })
