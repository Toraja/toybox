local M = {}

function M.append_trailing(str)
  local line_str = vim.api.nvim_get_current_line()
  if vim.endswith(line_str, str) then
    return
  end
  vim.fn.setline('.', line_str .. str)
end

local function append_or_remove_suffix(str, suffix)
  if vim.endswith(str, suffix) then
    return string.sub(str, 1, string.len(str) - string.len(suffix))
  end
  return str .. suffix
end

function M.toggle_trailing_current(str)
  vim.api.nvim_set_current_line(append_or_remove_suffix(vim.api.nvim_get_current_line(), str))
end

function M.toggle_trailing_visual(str)
  local line_num_current = vim.fn.line("v")
  local line_num_other_end = vim.fn.line(".")
  local start_line_num = math.min(line_num_current, line_num_other_end)
  local end_line_num = math.max(line_num_current, line_num_other_end)

  local target_lines = vim.api.nvim_buf_get_lines(0, start_line_num - 1, end_line_num, false)
  local new_lines = {}
  for _, line in ipairs(target_lines) do
    table.insert(new_lines, append_or_remove_suffix(line, str))
  end
  vim.api.nvim_buf_set_lines(0, start_line_num - 1, end_line_num, false, new_lines)
end

function M.map_toggle_trailing(key, str, buffer)
  vim.keymap.set({ 'n', 'i' }, '<M-' .. key .. '>',
    function() require("text.edit").toggle_trailing_current(str) end, { silent = true, buffer = buffer })
  vim.keymap.set('x', '<M-' .. key .. '>', function() require("text.edit").toggle_trailing_visual(str) end,
    { silent = true, buffer = buffer })
end

return M
