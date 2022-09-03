local M = {}

local function wrap_as_cmd(cmd)
  return '<Cmd>' .. cmd .. '<CR>'
end

local function wrap_as_editable(cmd)
  return ':' .. cmd .. ' '
end

function M.register_with_editable(prompt, prefix_key, edit_key, cmds)
  local edit_prefix_key = prefix_key .. edit_key
  local wk = require("which-key")
  wk.register({ [prefix_key] = { name = prompt } })
  wk.register({ [edit_prefix_key] = { name = "Edit command" } })

  for _, cmd in ipairs(cmds) do
    vim.keymap.set('n', prefix_key .. cmd[1], wrap_as_cmd(cmd[2]), cmd[3])
    vim.keymap.set('n', edit_prefix_key .. cmd[1], wrap_as_editable(cmd[2]), cmd[3])
  end
end

return M
