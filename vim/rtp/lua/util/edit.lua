local M = {}

local function has_suffix(s, suffix)
  return s:sub(-string.len(suffix)) == suffix
end

function M.append(str)
  local line_str = vim.fn.getline('.')
  if has_suffix(line_str, str) then
    return
  end
  vim.fn.setline('.', line_str .. str)
end

local function toggle_trailing(line_num, str)
  local line_str = vim.api.nvim_buf_get_lines(0, line_num - 1, line_num, false)[1]
  if has_suffix(line_str, str) then
    vim.api.nvim_buf_set_lines(0, line_num - 1, line_num, false,
      { string.sub(line_str, 1, string.len(line_str) - string.len(str)) })
    return
  end
  vim.api.nvim_buf_set_lines(0, line_num - 1, line_num, false, { line_str .. str })
end

function M.toggle_trailing_current(str)
  toggle_trailing(vim.fn.line('.'), str)
end

function M.toggle_trailing_visual(str)
  local line_num_current = vim.fn.line("v")
  local line_num_other_end = vim.fn.line(".")
  local first = math.min(line_num_current, line_num_other_end)
  local last = math.max(line_num_current, line_num_other_end)
  for line = first, last do
    toggle_trailing(line, str)
  end
end

function M.map_toggle_trailing(key, str, buffer)
  vim.keymap.set({ 'n', 'i' }, '<M-' .. key .. '>',
    '<Cmd>lua require("util.edit").toggle_trailing_current("' .. str .. '")<CR>',
    { silent = true, buffer = buffer })
  vim.keymap.set('x', '<M-' .. key .. '>', '<Cmd>lua require("util.edit").toggle_trailing_visual("' .. str .. '")<CR>',
    { silent = true, buffer = buffer })
end

return M
