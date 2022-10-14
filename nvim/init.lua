---@diagnostic disable:lowercase-global

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

vim.g.ft_leader_key = '-'

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

wk.register({
  g = {
    name = "vimgrep",
    ["<Space>"] = { "<Cmd>call QuickGrep(expand('<cword>'), 0)<CR>", "<cword>" },
    x = { "<Cmd>call QuickGrep('\\<' . expand('<cword>') . '\\>', 0)<CR>", "<cword> exclusive" },
    [":"] = { "<Cmd>call QuickGrep('', 1)<CR>", "manual" },
  },
}, { prefix = "<Leader>" })
wk.register({
  g = {
    name = "vimgrep",
    ["<Space>"] = { "y<Cmd>call QuickGrep(@@, 0)<CR>", "selected" },
    x = { "y<Cmd>call QuickGrep('\\<' . @@ . '\\>', 0)<CR>", "selected exclusive" },
  },
}, { prefix = "<Leader>", mode = "v" })

wk.register({
  s = {
    name = "Substitute",
    ["<Space>"] = { "<Cmd>call QuickSubstitute(expand('<cword>'), {'range': '%'})<CR>", "case insensitive" },
    c = { "<Cmd>call QuickSubstitute(expand('<cword>'), {'range': '%', 'case': 1})<CR>", "case sensitive" },
    x = {
      name = "exclusive",
      ["<Space>"] = { "<Cmd>call QuickSubstitute(expand('<cword>'), {'range': '%', 'exclusive': 1})<CR>",
        "case insensitive" },
      c = { "<Cmd>call QuickSubstitute(expand('<cword>'), {'range': '%', 'exclusive': 1, 'case': 1})<CR>",
        "case sensitive" },
    },
    [":"] = { "<Cmd>call QuickSubstitute('', {'range': '%'})<CR>", "manual" },
    ["."] = { "<Cmd>call QuickSubstitute('', {})<CR>", "manual on current line" },
  },
}, { prefix = "<Leader>" })
wk.register({
  s = {
    name = "Substitute",
    ["<Space>"] = { "y<Cmd>call QuickSubstitute(@@, {'range': '%'})<CR>", "case insensitive" },
    c = { "y<Cmd>call QuickSubstitute(@@, {'range': '%', 'case': 1})<CR>", "case sensitive" },
    x = {
      name = "exclusive",
      ["<Space>"] = { "y<Cmd>call QuickSubstitute(@@, {'range': '%', 'exclusive': 1})<CR>", "case insensitive" },
      c = { "y<Cmd>call QuickSubstitute(@@, {'range': '%', 'exclusive': 1, 'case': 1})<CR>", "case sensitive" },
    },
    [":"] = { "<Esc><Cmd>call QuickSubstitute('', {'range': '%', 'selection': 1})<CR>", "manual within selection" },
  },
}, { prefix = "<Leader>", mode = "v" })

wk.register({
  ["_"] = {
    name = "nice ones",
    c = { "<Cmd>lcd %:p:h | echo 'lcd -> ' . expand('%:p:h')<CR>", "lcd to the file's dir" },
    d = { "<Cmd>echo 'current dir: ' . getcwd()<CR>", "Print current dir" },
    p = { "<Cmd>echo 'filepath: ' . expand('%:p')<CR>", "Print current file's absolute path" },
    w = { "<Cmd>set wrap!<CR>", "Toggle wrap" },
  },
})

vim.keymap.set('i', '<C-g><C-q>', '<C-o>gql<End>')
vim.keymap.set('!', '<C-q><C-b>', "expand('%:t')", { desc = "Buffer's basename", expr = true })
vim.keymap.set('!', '<C-q><C-s>', "expand('%:t:r')", { desc = "Buffer's simple name", expr = true })
vim.keymap.set('!', '<C-q><C-d>', "expand('%:p:h')", { desc = "Buffer's directory", expr = true })
vim.keymap.set('!', '<C-q><C-f>', "expand('%:p')", { desc = "Buffer's absolute path", expr = true })
vim.keymap.set('!', '<C-q><C-p>', "getcwd()", { desc = "cwd", expr = true })

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
    -- this has to be vim command as the function is not defined here and function reference cannot be used.
    n = { '<Cmd>lua build_fennel_ftplugins()<CR>', 'Build fennel ftplugins' },
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
