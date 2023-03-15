-- nvim-tree recommends to this if netrw is disabled
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require('plugins')
local array = require('util.array')
local wk = require("which-key")

array.new({ 'cfilter', 'termdebug' }):for_each(function(pack)
  vim.cmd('packadd ' .. pack)
end)

vim.opt.mouse = ''

-- highlight
-- vim.api.nvim_set_hl(0, 'String', { ctermfg = 216 })
-- vim.api.nvim_set_hl(0, 'Comment', { ctermfg = 246 })
-- vim.api.nvim_set_hl(0, 'Folded', { ctermfg = 246, fg = '#41535b' })
-- vim.api.nvim_set_hl(0, 'PmenuSel', { ctermfg = 254, ctermbg = 240, bold = true, bg = 'Blue' })
-- vim.api.nvim_set_hl(0, 'Pmenu', { ctermfg = 254, ctermbg = 236, bg = 'DarkGrey' })
-- vim.api.nvim_set_hl(0, 'ColorColumn', { ctermbg = 6, bg = 'DarkCyan' })

local highlight_augroud_id = vim.api.nvim_create_augroup('custom_highlight', {})
vim.api.nvim_create_autocmd({ "BufWinEnter", "InsertEnter", "InsertLeave" }, {
  group = highlight_augroud_id,
  desc = "Highlight trailing whitespaces and mixture of space and tab",
  pattern = "*",
  callback = function()
    local exclude_filetype = array.new({ 'help', 'toggleterm' })
    if exclude_filetype:contains(vim.opt.filetype:get()) then
      return
    end
    vim.cmd([[syntax match AnnoyingSpaces "\s\+$\| \+\t\+\|\t\+ \+"]])
  end,
})


local terminal_augroud_id = vim.api.nvim_create_augroup('terminal', {})
vim.api.nvim_create_autocmd("TermOpen", {
  group = terminal_augroud_id,
  desc = "Setup terminal",
  -- Run this autocmd only if the current buffer is terminal, or it enters insert mode even when backgroud terminal job dispatches.
  pattern = "term://*",
  callback = function()
    vim.cmd([[
      syntax clear
      setlocal nonumber signcolumn=no
      startinsert
    ]])
  end,
})

vim.g.termdebug_wide = 1
wk.register({
  g = {
    name = "termdebug",
    a = { "<Cmd>Arguments<CR>", "Set arguments to the next :Run" },
    b = { "<Cmd>Break<CR>", "Add breakpoint" },
    B = { "<Cmd>Clear<CR>", "Clear breakpoint" },
    c = { "<Cmd>Continue<CR>", "Continue" },
    f = { "<Cmd>Finish<CR>", "Finish" },
    g = { "<Cmd>GdbIns<CR>", "Jump to gbd" },
    i = { "<Cmd>Step<CR>", "Step in" },
    n = { "<Cmd>Over<CR>", "Step over" },
    o = { "<Cmd>Program<CR>", "Jump to program" },
    r = { "<Cmd>Run<CR>", "Run the program with arguments" },
    s = { "<Cmd>Source<CR>", "Jump to source" },
    x = { "<Cmd>Stop<CR>", "Stop (interrupt the program)" },
  },
}, { prefix = vim.g.chief_key })

function gdb_ins()
  vim.cmd([[
    Gdb
    startinsert
  ]])
end

vim.api.nvim_create_user_command('GdbIns', gdb_ins, {})

require('register')

wk.register({
  ["_"] = {
    name = "nice ones",
    c = { "<Cmd>lcd %:p:h | echo 'lcd -> ' . expand('%:p:~:h')<CR>", "lcd to the file's dir" },
    w = { "<Cmd>set wrap!<CR>", "Toggle wrap" },
  },
})

vim.keymap.set('i', '<C-g><C-q>', '<C-o>gql<End>')
vim.keymap.set('!', '<C-q><C-b>', "expand('%:t')", { desc = "Buffer's basename", expr = true })
vim.keymap.set('!', '<C-q><C-s>', "expand('%:t:r')", { desc = "Buffer's simple name", expr = true })
vim.keymap.set('!', '<C-q><C-d>', "expand('%:p:~:h')", { desc = "Buffer's directory", expr = true })
vim.keymap.set('!', '<C-q><C-f>', "expand('%:p:~')", { desc = "Buffer's absolute path", expr = true })
vim.keymap.set('!', '<C-q><C-p>', "getcwd()", { desc = "cwd", expr = true })

require('text.edit').map_toggle_trailing(',', ',')

function delete_hidden_buffers()
  local visible_buffers = array.new()
  for i = 1, vim.fn.tabpagenr('$') do
    visible_buffers:append(vim.fn.tabpagebuflist(i))
  end

  local hidden_bufs = array.new()
  for i = 1, vim.fn.bufnr('$') do
    if vim.fn.bufexists(i) == 1 and not visible_buffers:contains(i) then
      hidden_bufs:insert(i)
    end
  end

  hidden_bufs:for_each(function(bufnr)
    vim.cmd(string.format('silent bwipeout %s', bufnr))
  end)
end

vim.api.nvim_create_user_command('DeleteHiddenBuffers', delete_hidden_buffers, {})

function qf_files_open()
  local qflist = array.new(vim.fn.getqflist())
  if #qflist == 0 then
    print('qflist is empty')
    return
  end

  local current_tab_number = vim.fn.tabpagenr()

  qflist:for_each(function(qf)
    local filepath = qf['text']
    if vim.fn.filereadable(filepath) == 1 then
      vim.cmd('tabnew ' .. filepath)
    else
      print(string.format('%s not found', filepath))
    end
  end)

  vim.cmd('tabnext ' .. current_tab_number)
end

vim.api.nvim_create_user_command('QfFilesOpen', qf_files_open, {})

function plugin_unload(name)
  package.loaded[name] = nil
end

vim.api.nvim_create_user_command('PluginUnload', function(opts)
  plugin_unload(opts.args)
end, { nargs = 1 })

function plugin_reload()
  package.loaded['plugins'] = nil
  require('plugins')
end

function plugin_recompile()
  vim.api.nvim_create_autocmd('User', {
    pattern = 'PackerCompileDone',
    callback = function()
      print('Compiling plugins completed')
      return true
    end
  })
  plugin_reload()
  require('packer').compile()
end

function plugin_install_recompile()
  vim.api.nvim_create_autocmd('User', {
    pattern = 'PackerComplete',
    callback = function()
      require('packer').compile()
      return true
    end
  })
  plugin_reload()
  require('packer').install()
end

function plugin_resync()
  plugin_reload()
  require('packer').sync()
end

wk.register({
  ['<F3>'] = {
    name = 'Source rc file',
    ['<F3>'] = { '<Cmd>source $MYVIMRC<CR>', 'Reload $MYVIMRC' },
    g = { '<Cmd>source $MYGVIMRC<CR>', 'Reload $MYGVIMRC' },
    f = { '<Cmd>SetFt<CR>', 'Reload ftplugin' },
    r = { plugin_recompile, 'Recompile plugins' },
    i = { plugin_install_recompile, 'Install plugins and compile' },
    s = { plugin_resync, 'Resync plugins' },
    o = {
      name = 'Open',
      v = { '<Cmd>tabnew $MYVIMRC<CR>', 'Open $MYVIMRC' },
      f = { '<Cmd>call OpenFtplugins(&ft)<CR>', "Open ftplugins" },
    },
  },
})

function preserve_cursor(func)
  local cursor_position = vim.fn.getpos('.')
  local current_line, current_column = cursor_position[2], cursor_position[3]
  func()
  vim.fn.cursor(current_line, current_column)
end
