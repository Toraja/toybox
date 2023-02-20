local M = {}

local function wrap_as_cmd(cmd)
  return '<Cmd>' .. cmd .. '<CR>'
end

local function wrap_as_editable(cmd)
  return ':' .. cmd .. ' '
end

function M.register_with_editable(prompt, prefix_key, edit_key, cmds, opts)
  local edit_prefix_key = prefix_key .. edit_key
  local wk = require("which-key")
  -- Use which-key only to set the name of grouping
  wk.register({ [prefix_key] = { name = prompt } }, opts)
  wk.register({ [edit_prefix_key] = { name = "Edit command" } }, opts)

  for key, cmd in pairs(cmds) do
    vim.keymap.set('n', prefix_key .. key, wrap_as_cmd(cmd[1]), cmd[2])
    vim.keymap.set('n', edit_prefix_key .. key, wrap_as_editable(cmd[1]), cmd[2])
  end
end

return M
