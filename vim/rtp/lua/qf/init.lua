local M = {}

local function quickfix_list_toggle()
  local qf_win_id = vim.fn.getqflist({ winid = 0 }).winid
  if qf_win_id == 0 then
    local current_win_id = vim.fn.win_getid()
    if not pcall(function() vim.cmd('copen') end) then
      print('No quickfix list')
      return
    end
    vim.fn.win_gotoid(current_win_id)
  else
    vim.cmd('cclose')
  end
end

local function location_list_toggle()
  local loclist_win_id = vim.fn.getloclist(0, { winid = 0 }).winid
  if loclist_win_id == 0 then
    local current_win_id = vim.fn.win_getid()
    if not pcall(function() vim.cmd('lopen') end) then
      print('No location list')
      return
    end
    vim.fn.win_gotoid(current_win_id)
  else
    vim.cmd('lclose')
  end
end

local function qf_files_open()
  local qflist = vim.fn.getqflist()
  if #qflist == 0 then
    print('qflist is empty')
    return
  end

  local current_tab_number = vim.fn.tabpagenr()

  vim.tbl_map(function(qf)
    local filepath = qf['text']
    if vim.fn.filereadable(filepath) == 1 then
      vim.cmd('tabnew ' .. filepath)
      -- Tab opened by tabnew uses the same option of current win.
      -- nvim-bqf disables signcolumn in qf window so it is disabled in the opened tab.
      vim.api.nvim_win_set_option(vim.api.nvim_get_current_win(), 'signcolumn', 'yes')
    else
      print(string.format('%s not found', filepath))
    end
  end, qflist)

  vim.cmd('tabnext ' .. current_tab_number)
end

function M.setup(opts)
  opts = opts or {}
  vim.keymap.set('n', '<C-q><C-q>', quickfix_list_toggle, { desc = 'Toggle quickfix window' })
  vim.keymap.set('n', '<C-q><C-l>', location_list_toggle, { desc = 'Toggle loation list window' })

  vim.api.nvim_create_user_command('QfFilesOpen', qf_files_open, {})
end

return M
