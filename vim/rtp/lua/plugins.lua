---@diagnostic disable:lowercase-global
---@diagnostic disable:need-check-nil

local packer_install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
local packer_bootstrap = nil
if vim.fn.empty(vim.fn.glob(packer_install_path)) > 0 then
  packer_bootstrap = vim.fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim',
    packer_install_path })
  vim.cmd([[packadd packer.nvim]])
end

local hotpot_install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/hotpot.nvim'
local hotpot_cache_path = vim.fn.stdpath('cache') .. '/hotpot'
if vim.fn.empty(vim.fn.glob(hotpot_cache_path)) > 0 then
  -- hotpot complains and loading rc files gets aborted if hotpot is installed but cache does not exist
  vim.fn.delete(hotpot_install_path, 'rf')
end
if vim.fn.empty(vim.fn.glob(hotpot_install_path)) > 0 then
  print("Could not find hotpot.nvim, cloning new copy to", hotpot_install_path)
  vim.fn.system({ 'git', 'clone', 'https://github.com/rktjmp/hotpot.nvim', hotpot_install_path })
  vim.cmd("helptags " .. hotpot_install_path .. "/doc")
end

return require('packer').startup(function(use)
  --[[
    setup/config inside `requires` seems not working.
    Plugins which need configuraton but are only dependencies of another plugins
    must be marked as `-- dependency`
  ]]
  use 'wbthomason/packer.nvim'
  use {
    'rktjmp/hotpot.nvim',
    config = function()
      require('hotpot').setup()

      function build_fennel_ftplugins(opt)
        local build_opt = opt or {}
        require('hotpot.api.make').build('~/toybox/vim/rtp/ftplugin',
          build_opt,
          '(.+)/toybox/vim/rtp/ftplugin/(.+)',
          function(home, filename)
            return home .. '/.config/nvim/ftplugin/' .. filename
          end)
      end

      build_fennel_ftplugins({ verbosity = 0 })
    end
  }
  use {
    'folke/which-key.nvim',
    config = function()
      vim.cmd([[
        highlight link FloatBorder Normal
        highlight link WhichKeyFloat Normal
        highlight link WhichKey Type
        highlight link WhichKeyDesc Type
      ]])
      require("which-key").setup {
        plugins = {
          presets = {
            operators = false, -- adds help for operators like d, y, ...
          },
        },
        operators = {
          d = "Delete",
          c = "Change",
          y = "Yank (copy)",
          ["g~"] = "Toggle case",
          ["gu"] = "Lowercase",
          ["gU"] = "Uppercase",
          [">"] = "Indent right",
          ["<lt>"] = "Indent left",
          ["zf"] = "Create fold",
          ["!"] = "Filter though external program",
          -- ["v"] = "Visual Character Mode",
          gc = "Comments"
        },
        popup_mappings = {
          scroll_down = '<PageDown>', -- binding to scroll down inside the popup
          scroll_up = '<PageUp>', -- binding to scroll up inside the popup
        },
        window = {
          border = "rounded", -- none, single, double, shadow
          position = "bottom", -- bottom, top
          margin = { 0, 0, 0, 0 }, -- extra window margin [top, right, bottom, left]
          padding = { 1, 2, 1, 2 }, -- extra window padding [top, right, bottom, left]
          winblend = 0 -- value between 0-100 0 for fully opaque and 100 for fully transparent
        },
        layout = {
          height = { min = 4, max = 25 }, -- min and max height of the columns
          width = { min = 20, max = 50 }, -- min and max width of the columns
          spacing = 5, -- spacing between columns
          align = "left", -- align columns left, center or right
        },
      }
    end
  }

  -- git
  use {
    'tpope/vim-fugitive',
    config = function()
      vim.cmd([[
        cnoreabbrev gs Git
        cnoreabbrev gg Git log
        cnoreabbrev ggg vertical sbuffer <Bar> Gllog
        cnoreabbrev gd Gvdiffsplit
        cnoreabbrev gp Git push
      ]])
      -- vim.g.fugitive_no_maps = 1 -- prevent <C-n/p> to be mapped
      vim.keymap.set('n', '<Leader>vs', "<Cmd>tab Git<CR>", { desc = "vim-fugitive" })
      vim.keymap.set('n', '<Leader>vG', "<Cmd>tab Git log<CR>", { desc = "git log [tab]" })
      vim.keymap.set('n', '<Leader>vg', "<Cmd>vertical Git log<CR>", { desc = "git log [vert]" })
      vim.keymap.set('n', '<Leader>vB', "<Cmd>Git blame<CR>", { desc = "git blame entire file" })
    end
  }
  use {
    'junegunn/gv.vim',
    config = function()
      vim.keymap.set('n', '<Leader>vV', "<Cmd>GV<CR><Cmd>+tabmove<CR>", { desc = "GV [repo]" })
      vim.keymap.set('n', '<Leader>vv', "<Cmd>GV!<CR><Cmd>+tabmove<CR>", { desc = "GV [file]" })
    end
  }
  use {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup({
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map('n', ']c', function()
            if vim.wo.diff then return ']c' end
            vim.schedule(function() gs.next_hunk() end)
            return '<Ignore>'
          end, { expr = true, desc = 'Next hunk' })

          map('n', '[c', function()
            if vim.wo.diff then return '[c' end
            vim.schedule(function() gs.prev_hunk() end)
            return '<Ignore>'
          end, { expr = true, desc = 'Previous hunk' })

          -- Actions
          map({ 'n', 'x' }, '<leader>vhs', '<Cmd>Gitsigns stage_hunk<CR>', { desc = 'Stage this hunk' })
          map('n', '<leader>vhS', gs.stage_buffer, { desc = 'Stage all changes in the buffer' })
          map({ 'n', 'x' }, '<leader>vhr', '<Cmd>Gitsigns reset_hunk<CR>', { desc = 'Restore this hunk to index' })
          map('n', '<leader>vhR', gs.reset_buffer, { desc = 'Restore all unstaged changes in the buffer to index' })
          map('n', '<leader>vhu', gs.undo_stage_hunk, { desc = 'Unstage the last staged hunk' })
          map('n', '<leader>vhp', gs.preview_hunk, { desc = 'Preview this hunk' })
          map('n', '<leader>vd', gs.diffthis, { desc = 'vimdiff against index' })
          map('n', '<leader>vD', function() gs.diffthis('~') end, { desc = 'vimdiff against last commit' })
          map('n', '<leader>vb', function() gs.blame_line({ full = true }) end, { desc = 'Blame current line' })
          map('n', '<leader>v<C-b>', gs.toggle_current_line_blame,
            { desc = 'Toggle git blame current line virtual text' })

          -- Text object
          map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'Select hunk' })
        end
      })
    end
  }

  -- look & feel
  -- nvim-web-devicons requires external font such as https://www.nerdfonts.com/
  use 'kyazdani42/nvim-web-devicons'
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true },
    after = 'one_monokai.nvim',
    config = function()
      vim.o.showmode = false

      local function mode_with_paste()
        local lualine_mode_map = require('lualine.utils.mode').map
        local mode = lualine_mode_map[vim.fn.mode()]
        if vim.o.paste then
          mode = mode .. ' (PASTE)'
        end
        return mode
      end

      require('lualine').setup({
        options = {
          theme = 'ayu_mirage',
          disabled_filetypes = {
            -- statusline = {},
            winbar = { 'help', 'qf', 'gitcommit', 'fugitive', 'Trouble' },
          },
        },
        sections = {
          lualine_a = { mode_with_paste },
          lualine_b = { 'branch', 'diff', 'diagnostics' },
          lualine_c = { "vim.fn.fnamemodify(vim.fn.getcwd(), ':~')" },
        },
        inactive_sections = {
          lualine_c = { { 'filename', path = 3, show_modified_status = true, newfile_status = true } },
          lualine_x = { 'location' },
        },
        winbar = {
          lualine_c = { { 'filename', path = 1, show_modified_status = true, newfile_status = true } },
        },
        inactive_winbar = {
          lualine_c = { { 'filename', path = 3, show_modified_status = true, newfile_status = true } },
        },
        extensions = { 'fugitive', 'man', 'nvim-tree', 'quickfix' }
      })
    end,
  }
  use {
    'cpea2506/one_monokai.nvim',
    config = function()
      require("one_monokai").setup({
        colors = {
          bg = "NONE",
          cyan = '#00d7ff',
          claret = '#7f1734',
          castleton_green = '#00563f',
          dark_powder_blue = '#003399',
          cursor_line_bg = '#141414',
        },
        themes = function(colors)
          return {
            CursorLine = { bg = colors.cursor_line_bg },
            CursorLineNr = { fg = colors.fg, bg = colors.cursor_line_bg },
            DiffAdd = { bg = colors.castleton_green },
            DiffDelete = { fg = colors.claret, bg = colors.claret },
            DiffChange = { bg = colors.dark_gray },
            DiffText = { bg = colors.dark_powder_blue },
            Search = { fg = colors.yellow, bg = colors.bg, reverse = true },
            TabLine = { fg = colors.none, bg = colors.none, reverse = true },
            Todo = { fg = colors.pink, bold = true, italic = true, reverse = true },
            Blocked = { fg = colors.aqua, reverse = true },
            AnnoyingSpaces = { bg = colors.dark_gray },
          }
        end,
      })
    end,
  }
  use {
    'tanvirtin/monokai.nvim',
    disable = true,
    config = function()
      require('monokai').setup({
        palette = require('monokai').pro,
        -- palette = require('monokai').soda,
        -- palette = require('monokai').ristretto,
        custom_hlgroups = {
          Normal = { bg = '#000000' },
          CursorLine = { bg = '#151515' },
          TabLine = { reverse = true },
          AnnoyingSpaces = { bg = '#333842' },
        }
      })
    end,
  }

  -- finder (path/dir/file/buffer/tac/etc.)
  use {
    'kyazdani42/nvim-tree.lua',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true },
    config = function()
      require("nvim-tree").setup({
        hijack_netrw = true,
        respect_buf_cwd = true,
        update_cwd = true,
        update_focused_file = {
          enable = true,
          update_cwd = true,
        },
        git = {
          ignore = false,
        },
        view = {
          width = 40,
          mappings = {
            list = {
              { key = "<C-e>", action = '' },
              { key = "H", action = '' },
              { key = "s", action = '' },
            },
          },
        },
        renderer = {
          highlight_opened_files = "all",
        },
        actions = {
          open_file = {
            quit_on_open = true,
          },
        },
      })
      require('keymap.which-key-helper').register_with_editable('nvim-tree', vim.g.chief_key .. 'e', vim.g.chief_key, {
        { 'o', 'NvimTreeOpen', { desc = 'Open' } },
        { 'O', 'NvimTreeOpen %:h', { desc = 'Open in the file\'s parent directory' } },
        { 'e', 'NvimTreeToggle', { desc = 'Toggle' } },
        { 'E', 'NvimTreeFocus', { desc = 'Focus' } },
        { 'f', 'NvimTreeFindFile', { desc = 'Find file' } },
        { 'r', 'NvimTreeRefresh', { desc = 'Refresh' } },
      })
    end
  }
  use {
    'kevinhwang91/rnvimr',
    cond = function() return vim.fn.executable('ranger') end,
    config = function()
      vim.keymap.set('n', '<Leader>e', "<Cmd>RnvimrToggle<CR>", { desc = "ranger" })
      -- Hide the files included in gitignore
      vim.g.rnvimr_hide_gitignore = 1
      vim.g.rnvimr_edit_cmd = 'tabedit'
      vim.g.rnvimr_enable_picker = 1
      vim.g.rnvimr_layout = {
        relative = 'editor',
        width = vim.o.columns,
        height = vim.o.lines - 3,
        col = 0,
        row = 1,
        style = 'minimal',
      }
    end,
  }
  use {
    'preservim/tagbar',
    disable = true,
    config = function()
      vim.keymap.set('n', '<Leader>o', '<Cmd>TagbarToggle<CR>')
      vim.keymap.set('n', '<Leader>O', '<Cmd>TagbarOpen fj<CR>')
    end
  }
  use {
    'simrat39/symbols-outline.nvim',
    config = function()
      local symbols_outline = require("symbols-outline")
      symbols_outline.setup({
        autofold_depth = 2,
      })

      local function is_window_open_in_current_tab(win_id)
        return vim.fn.win_id2win(win_id) ~= 0
      end

      local function is_outline_open_in_current_tab()
        if not symbols_outline.view:is_open() then
          return false
        end
        return is_window_open_in_current_tab(symbols_outline.view.winnr)
      end

      local function symbols_outline_focus()
        if is_outline_open_in_current_tab() then
          vim.fn.win_gotoid(symbols_outline.view.winnr)
          return
        end

        if symbols_outline.view:is_open() then
          symbols_outline.close_outline()
        end

        symbols_outline.open_outline()
      end

      local function symbols_outline_toggle()
        if symbols_outline.view:is_open() then
          symbols_outline.close_outline()
          return
        end

        symbols_outline.open_outline()
      end

      vim.keymap.set('n', '<Leader>o', symbols_outline_toggle)
      vim.keymap.set('n', '<Leader>O', symbols_outline_focus)
    end
  }
  use {
    'stevearc/aerial.nvim',
    disable = true,
    config = function()
      require('aerial').setup()
    end
  }
  use {
    'ibhagwan/fzf-lua',
    disable = true,
    requires = { 'kyazdani42/nvim-web-devicons', opt = true },
    config = function()
      local fzf = require('fzf-lua')
      fzf.setup {
        winopts = {
          preview = {
            horizontal = 'right:50%', -- right|left:size
          },
        },
        keymap = {
          builtin = {
            -- command name (rhs) differs from ones of fzf
            -- e.g. `preview-half-page-down` does not work
            ["<M-j>"] = "preview-page-down",
            ["<M-k>"] = "preview-page-up",
            ["<M-g>"] = "preview-page-reset",
          },
        },
        grep = {
          rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=512 --hidden --glob !.git",
        },
      }
      ---@diagnostic disable-next-line:unused-function
      function fzf_lua_ghq()
        fzf.files({
          cmd = "ghq list --full-path",
          prompt = 'Repo❯ ',
          actions = {
            ["default"] = function(selected)
              -- FIXME the second fzf-lua does not enter insert mode automatically
              fzf.files({
                cwd = selected[1],
              })
            end,
          },
        })
      end

      -- {{{ || fzf-lua || ---
      -- function! s:InitFzfCmds()
      --   let l:fzf_cmds = {
      --         \ 'b': runcmds#init#MakeCmdInfo('FzfLua buffers'),
      --         \ 'f': runcmds#init#MakeCmdInfo('FzfLua files cwd=.'),
      --         \ 'F': runcmds#init#MakeCmdInfo('FzfLua files cwd=%:h'),
      --         \ 'o': runcmds#init#MakeCmdInfo('FzfLua oldfiles'),
      --         \ 'L': runcmds#init#MakeCmdInfo('FzfLua lines'),
      --         \ 'l': runcmds#init#MakeCmdInfo('FzfLua blines'),
      --         \ 't': runcmds#init#MakeCmdInfo('FzfLua tabs'),
      --         \ 'r': runcmds#init#MakeCmdInfo('FzfLua grep cwd=.'),
      --         \ 'g': runcmds#init#MakeCmdInfo('FzfLua git_files'),
      --         \ 'G': runcmds#init#MakeCmdInfo('FzfLua git_status'),
      --         \ 'C': runcmds#init#MakeCmdInfo('FzfLua git_commits'),
      --         \ 'c': runcmds#init#MakeCmdInfo('FzfLua git_bcommits'),
      --         \ 'h': runcmds#init#MakeCmdInfo('FzfLua help_tags'),
      --         \ 'd': runcmds#init#MakeCmdInfo('FzfLua commands'),
      --         \ ':': runcmds#init#MakeCmdInfo('FzfLua command_history'),
      --         \ '/': runcmds#init#MakeCmdInfo('FzfLua search_history'),
      --         \ 'k': runcmds#init#MakeCmdInfo('FzfLua marks'),
      --         \ 'm': runcmds#init#MakeCmdInfo('FzfLua keymaps'),
      --         \ 's': runcmds#init#MakeCmdInfo('FzfLua spell_suggest'),
      --         \ 'q': runcmds#init#MakeCmdInfo('lua fzf_lua_ghq()'),
      --         \ }
      --   function! s:FzfCmds() closure
      --     return l:fzf_cmds
      --   endfunction
      -- endfunction
      -- function! s:InitFzfFlagDict()
      --   let l:fzf_flags = runcmds#init#MakeFlagDict(';', "\<Space>")
      --   function! s:FzfFlags() closure
      --     return l:fzf_flags
      --   endfunction
      -- endfunction
      -- call s:InitFzfCmds()
      -- call s:InitFzfFlagDict()
      -- nnoremap <expr> [Chief]f runcmds#base#RunCmds("FZF", <SID>FzfCmds(), <SID>FzfFlags())
      -- --- || fzf-lua || }}}
    end
  }
  use {
    'nvim-telescope/telescope.nvim',
    after = { 'one_monokai.nvim' },
    requires = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
      { 'nvim-telescope/telescope-ghq.nvim' },
      { 'nvim-telescope/telescope-packer.nvim' },
    },
    config = function()
      -- NOTE This does not work properly at the moment...
      -- See https://github.com/nvim-telescope/telescope.nvim/issues/1661
      -- vim.cmd "autocmd User TelescopePreviewerLoaded setlocal number" -- Add line number to preview

      local telescope = require('telescope')
      local action = require('telescope.actions')
      local action_set = require('telescope.actions.set')
      local action_layout = require('telescope.actions.layout')
      local trouble = require("trouble.providers.telescope")
      telescope.setup({
        defaults = {
          vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--hidden",
            "--glob", "!.git",
          },
          sorting_strategy = 'ascending',
          -- wrap_results = true,
          path_display = { truncate = 1 },
          layout_config = {
            prompt_position = "top",
            horizontal = {
              width = 0.92,
              preview_width = 0.60,
            },
          },
          mappings = {
            n = {
              ["<C-d>"] = function(bufnr) action_set.scroll_results(bufnr, 1) end,
              ["<C-u>"] = function(bufnr) action_set.scroll_results(bufnr, 0) end,
              ["<M-j>"] = function(bufnr) action_set.scroll_previewer(bufnr, 1) end,
              ["<M-k>"] = function(bufnr) action_set.scroll_previewer(bufnr, 0) end,
              ["<c-q>"] = trouble.open_with_trouble,
            },
            i = {
              ["<c-q>"] = trouble.open_with_trouble,
              ["<Esc>"] = action.close,
              ["<C-\\>"] = { "<Esc>", type = "command" },
              ["<C-_>"] = action_layout.toggle_preview,
              ["<Tab>"] = action.move_selection_worse,
              ["<C-j>"] = function(bufnr)
                action.toggle_selection(bufnr)
                action.move_selection_worse(bufnr)
              end,
              ["<C-M-j>"] = function(bufnr)
                action.toggle_selection(bufnr)
                action.move_selection_better(bufnr)
              end,
              ["<M-<>"] = action.move_to_top,
              ["<M->>"] = action.move_to_bottom,
              ["<C-d>"] = { "<DEL>", type = "command" },
              ["<C-u>"] = { "<C-u>", type = "command" },
              ["<M-j>"] = function(bufnr) action_set.scroll_previewer(bufnr, 0.5) end,
              ["<M-k>"] = function(bufnr) action_set.scroll_previewer(bufnr, -0.5) end,
              ["<C-M-n>"] = action.cycle_history_next,
              ["<C-M-p>"] = action.cycle_history_prev,
              ["<M-?>"] = action.which_key,
            },
          },
        },
        pickers = {
          -- Default configuration for builtin pickers goes here:
          find_files = {
            find_command = { "fd", "--type", "f", "--hidden", "--exclude", ".git" },
          },
          -- Now the picker_config_key will be applied every time you call this
          -- builtin picker
        },
        extensions = {
          -- Your extension configuration goes here:
          -- extension_name = {
          --   extension_config_key = value,
          -- }
          -- please take a look at the readme of the extension you want to configure
        },
      })
      telescope.load_extension('fzf')
      telescope.load_extension('ghq')
      telescope.load_extension("packer")

      require('keymap.which-key-helper').register_with_editable('Telescope', vim.g.chief_key .. 'f', vim.g.chief_key, {
        { 'f', 'Telescope find_files search_dirs=.', { desc = 'Files' } },
        { 'r', 'Telescope live_grep layout_config={preview_width=0.5} search_dirs=.', { desc = 'Grep' } },
        { 'R', 'Telescope grep_string layout_config={preview_width=0.5} search_dirs=.',
          { desc = 'Grep with cursor word' } },
        { 'b', 'Telescope buffers', { desc = 'Buffers' } },
        { 'o', 'Telescope treesitter', { desc = 'Treesitter' } },
        { 'O', 'Telescope oldfiles layout_config={preview_width=0.5}', { desc = 'Oldfiles' } },
        { 'l', 'Telescope current_buffer_fuzzy_find', { desc = 'Buffer lines' } },
        { 'g', 'Telescope git_files', { desc = 'Git files' } },
        { 'G', 'Telescope git_status', { desc = 'Git status' } },
        { 'C', 'Telescope git_commits', { desc = 'Git commits' } },
        { 'c', 'Telescope git_bcommits', { desc = 'Git buffer commits' } },
        { 'h', 'Telescope help_tags', { desc = 'Help tags' } },
        { 'e', 'Telescope diagnostics', { desc = 'Diagnostics' } },
        { ':', 'Telescope command_history', { desc = 'Command history' } },
        { '/', 'Telescope search_history', { desc = 'Search history' } },
        { 'm', 'Telescope marks', { desc = 'Marks' } },
        { 'k', 'Telescope keymaps', { desc = 'Keymaps' } },
        { 's', 'Telescope spell_suggest', { desc = 'Spell suggest' } },
        { 'H', 'Telescope highlights', { desc = 'Highlights' } },
        { 'q', 'Telescope ghq list layout_config={preview_width=0.5}', { desc = 'Ghq list' } },
        { 'p', 'Telescope packer', { desc = 'Packer' } },
      })
    end,
  }

  -- moving around
  use {
    'phaazon/hop.nvim',
    after = 'one_monokai.nvim',
    config = function()
      local hop = require('hop')
      hop.setup {
        keys = 'asdfghjklqwertyuiopzxcvbnm;',
        uppercase_labels = true,
      }
      local hop_hint = require('hop.hint')
      local function hop_forward_to()
        hop.hint_char1({
          direction = hop_hint.HintDirection.AFTER_CURSOR,
          current_line_only = true,
          hint_offset = -1,
        })
      end

      local function hop_backward_to()
        hop.hint_char1({
          direction = hop_hint.HintDirection.BEFORE_CURSOR,
          current_line_only = true,
          hint_offset = 1,
        })
      end

      local function hop_forward_words_end()
        hop.hint_words({
          direction = hop_hint.HintDirection.AFTER_CURSOR,
          hint_position = hop_hint.HintPosition.END,
          current_line_only = true,
        })
      end

      local function hop_backword_words_end()
        hop.hint_words({
          direction = hop_hint.HintDirection.BEFORE_CURSOR_CURSOR,
          hint_position = hop_hint.HintPosition.END,
          current_line_only = true,
        })
      end

      vim.keymap.set({ 'n', 'x', 'o' }, 'f', "<Cmd>HopChar1CurrentLineAC<CR>")
      vim.keymap.set({ 'n', 'x', 'o' }, 'F', "<Cmd>HopChar1CurrentLineBC<CR>")
      vim.keymap.set({ 'n', 'x', 'o' }, 'sw', "<Cmd>HopWordAC<CR>")
      vim.keymap.set({ 'n', 'x', 'o' }, 'sb', "<Cmd>HopWordBC<CR>")
      vim.keymap.set({ 'n', 'x', 'o' }, 'se', hop_forward_words_end)
      vim.keymap.set({ 'n', 'x', 'o' }, 'sge', hop_backword_words_end)
      vim.keymap.set({ 'n', 'x', 'o' }, 'sj', "<Cmd>HopVerticalAC<CR>")
      vim.keymap.set({ 'n', 'x', 'o' }, 'sk', "<Cmd>HopVerticalBC<CR>")
      vim.keymap.set({ 'n', 'x', 'o' }, 's/', "<Cmd>HopPatternAC<CR>")
      vim.keymap.set({ 'n', 'x', 'o' }, 's?', "<Cmd>HopPatternBC<CR>")
      vim.keymap.set('o', 't', hop_forward_to)
      vim.keymap.set('o', 'T', hop_backward_to)

      -- repeating is not implemented yet
      -- map s. <Plug>(easymotion-repeat)
      -- map <Bslash> <Plug>(easymotion-next)
      -- map <Bar> <Plug>(easymotion-prev)
    end
  }
  use {
    'michaeljsmith/vim-indent-object',
    config = function()
      vim.keymap.set('n', 'yx', 'yaI\']p',
        { remap = true, desc = 'Yank lines with the parent indent block and paste below the block' })
    end
  }
  use {
    'jeetsukumaran/vim-indentwise',
    config = function()
      vim.keymap.set({ 'n', 'x', 'o' }, '{', '<Plug>(IndentWisePreviousEqualIndent)', { desc = 'Previous equal indent' })
      vim.keymap.set({ 'n', 'x', 'o' }, '}', '<Plug>(IndentWiseNextEqualIndent)', { desc = 'Next equal indent' })
    end
  }
  use {
    'bkad/CamelCaseMotion',
    config = function()
      vim.keymap.set({ 'n', 'x', 'o' }, '<M-w>', '<Plug>CamelCaseMotion_w', { silent = true })
      vim.keymap.set({ 'n', 'x', 'o' }, '<M-b>', '<Plug>CamelCaseMotion_b', { silent = true })
      vim.keymap.set('o', 'im', '<Plug>CamelCaseMotion_ie', { silent = true, desc = 'Inner camel' })
      vim.keymap.set('x', 'im', '<Plug>CamelCaseMotion_ie', { silent = true, desc = 'Inner camel' })
      vim.keymap.set('o', 'am', '<Plug>CamelCaseMotion_iw', { silent = true, desc = 'A camel' })
      vim.keymap.set('x', 'am', '<Plug>CamelCaseMotion_iw', { silent = true, desc = 'A camel' })
    end
  }

  -- editting
  use {
    'bfredl/nvim-miniyank',
    config = function()
      vim.g.miniyank_maxitems = 20
      vim.keymap.set({ 'n', 'x', 'o' }, 'p', '<Plug>(miniyank-autoput)')
      vim.keymap.set({ 'n', 'x', 'o' }, 'P', '<Plug>(miniyank-autoPut)')
      vim.keymap.set({ 'n', 'x', 'o' }, '<M-p>', '<Plug>(miniyank-cycle)')
      vim.keymap.set({ 'n', 'x', 'o' }, '<M-P>', '<Plug>(miniyank-cycleback)')
    end,
  }
  use 'gpanders/editorconfig.nvim'
  use {
    'lukas-reineke/indent-blankline.nvim',
    config = function()
      vim.api.nvim_set_hl(0, 'IndentBlanklineChar', { ctermfg = 59 })
      vim.api.nvim_set_hl(0, 'IndentBlanklineSpaceChar', {}) -- this highlight overlaps cursorline. set None to prevent it.

      require("indent_blankline").setup {
        char = "¦",
        show_first_indent_level = false,
        filetype_exclude = { 'markdown', 'json', 'nerdtree', 'NvimTree', 'man' }
      }
    end,
  }
  use {
    'numToStr/Comment.nvim',
    config = function()
      local ft = require('Comment.ft')
      require('Comment').setup({
        ignore = '^$',
        ft.set('asciidoc', { '//%s', '////%s////' }),
      })
      -- XXX not working
      -- vim.keymap.set('i', '<C-\\>', '<C-o>gcc', { remap = true, silent = true } )
      vim.keymap.set('n', 'gcy', 'yy<Plug>(comment_toggle_linewise_current)', { silent = true })
      vim.keymap.set('x', 'gcy', 'ygv<Plug>(comment_toggle_linewise_visual)', { silent = true })
    end
  }
  use {
    'preservim/nerdcommenter',
    disable = true,
    config = function()
      vim.g.NERDSpaceDelims = 1 -- Add spaces after comment delimiters
      vim.g.NERDDefaultAlign = 'left'
      vim.keymap.set({ 'n', 'x', 'i' }, '<C-\\>', '<Plug>NERDCommenterToggle')
    end
  }
  use 'arthurxavierx/vim-caser'
  use({
    'kylechui/nvim-surround',
    tag = "*", -- Use for stability; omit to use `main` branch for the latest features
    config = function()
      require('nvim-surround').setup({
        keymaps = {
          insert = "<C-g>r",
          insert_line = "<C-g>R",
          normal = "yr",
          normal_cur = "yrr",
          normal_line = "yR",
          normal_cur_line = "yRR",
          visual = "R",
          visual_line = "gR",
          delete = "dr",
          change = "cr",
        },
        surrounds = {
          ["d"] = {
            add = { "${", "}" },
            find = function()
              return M.get_selection({ motion = "a${" })
            end,
            -- delete = "^(. ?)().-( ?.)()$", -- not working
          },
          ["D"] = {
            add = { "\"${", "}\"" },
            find = function()
              return M.get_selection({ motion = "a\"${" })
            end,
            -- delete = "^(. ?)().-( ?.)()$", -- not working
          },
          ["s"] = {
            add = { "$(", ")" },
            find = function()
              return M.get_selection({ motion = "a$(" })
            end,
            -- delete = "^(. ?)().-( ?.)()$", -- not working
          },
          ["S"] = {
            add = { "\"$(", ")\"" },
            find = function()
              return M.get_selection({ motion = "a\"$(" })
            end,
            -- delete = "^(. ?)().-( ?.)()$", -- not working
          },
        }
      })
    end
  })
  use {
    "windwp/nvim-autopairs",
    config = function()
      local ap = require("nvim-autopairs")
      local Rule = require('nvim-autopairs.rule')
      ap.setup({
        map_c_h = true,
        map_c_w = true,
        fast_wrap = {
          map = '<M-p>',
          keys = 'asdfghjklqwertyuiopzxcvbnm',
          end_keys = ';',
        },
      })
      ap.remove_rule("'")
      ap.add_rules({
        Rule('<', '>', { 'rust' }),
        Rule("'", "'", { '-rust' }),
      })
    end
  }
  use {
    'jiangmiao/auto-pairs',
    disable = true,
    config = function()
      vim.g.AutoPairsShortcutToggle = ''
      vim.g.AutoPairsShortcutFastWrap = '<M-p>'
      vim.g.AutoPairsShortcutJump = '<M-n>'
      vim.g.AutoPairsShortcutBackInsert = '<M-\\>'
      vim.g.AutoPairsMapSpace = 0 -- Enabling this maps <Space> to <C-]><C-R>=... and <C-]> is unwanted
      vim.g.AutoPairsMultilineClose = 0
      vim.keymap.set('i', '<Space>', '<C-g>u<C-r>=AutoPairsSpace()<CR>', { silent = true })
    end,
  }
  use 'AndrewRadev/splitjoin.vim'
  use 'tpope/vim-repeat'
  use 'junegunn/vim-easy-align'
  use {
    'neovim/nvim-lspconfig',
    config = function()
      -- 'java': [$HOME.'/toybox/vim/helper/java-lsp.sh', '-data', getcwd()],
      -- 'javascript': ['typescript-language-server', '--stdio'],
      -- 'php': [s:plugin_dir . '/phpactor/bin/phpactor', 'language-server'],

      vim.cmd([[highlight link NormalFloat Normal]])
      -- vim.lsp.set_log_level("debug")

      local lspconfig = require('lspconfig')
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
      capabilities.textDocument.completion.completionItem.resolveSupport = {
        properties = {
          'documentation',
          'detail',
          'additionalTextEdits', -- XXX currently failing to enable auto import for rust-analyzer
        }
      }

      -- Set border for floating window
      -- This does not work
      -- LSP settings (for overriding per client)
      -- local handlers =  {
      --   ["textDocument/hover"] =  vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded' }),
      --   ["textDocument/signatureHelp"] =  vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'rounded' }),
      -- }
      local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
      function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
        opts = opts or {}
        opts.border = opts.border or 'rounded'
        -- opts.max_width = opts.border or 100 -- <- this causes error
        opts.max_width = 100
        return orig_util_open_floating_preview(contents, syntax, opts, ...)
      end

      local servers = { 'gopls', 'pyright', 'rust_analyzer', 'sumneko_lua' }
      for _, lsp in pairs(servers) do
        lspconfig[lsp].setup({
          capabilities = capabilities,
        })
      end
      lspconfig['rust_analyzer'].setup({
        init_options = {
          completion = {
            addCallParenthesis = false,
            addCallArgumentSnippets = false,
          },
          diagnostics = {
            disabled = {
              "inactive-code",
            },
          },
        },
      })
      -- 'rust': ['rustup', 'run', !empty($RUST_VERSION) ? $RUST_VERSION : 'stable', 'rust-analyzer'],
      lspconfig['sumneko_lua'].setup({
        settings = {
          Lua = {
            runtime = {
              -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
              version = 'LuaJIT',
            },
            diagnostics = {
              -- Get the language server to recognize the `vim` global
              globals = { 'vim' },
            },
            workspace = {
              -- Make the server aware of Neovim runtime files
              library = vim.api.nvim_get_runtime_file("", true),
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
              enable = false,
            },
            format = {
              enable = true,
              -- Put format options here
              -- NOTE: the value should be STRING!!
              defaultConfig = {
                indent_style = "space",
                indent_size = "2",
              }
            },
          },
        },
      })
      lspconfig['yamlls'].setup({
        -- settings = {
        --   yaml = {
        --     schemas = {},
        --   },
        -- },
      })

      vim.keymap.set('i', '<C-g><C-h>', '<Cmd>lua vim.lsp.buf.signature_help()<CR>', { desc = 'Signature help' })
      vim.keymap.set('n', '<C-]>', '<Cmd>lua vim.lsp.buf.definition()<CR>', { desc = 'Definition' })
      vim.keymap.set('n', 'g<C-]>', '<Cmd>lua vim.lsp.buf.implementation<CR>', { desc = 'Implementation' })
      vim.keymap.set('n', '<C-w><C-]>', '<Cmd>split | lua vim.lsp.buf.definition()<CR>', { desc = 'Definition [horz]' })
      vim.keymap.set('n', '<C-w><C-g><C-]>', '<Cmd>split | lua vim.lsp.buf.implementation<CR>',
        { desc = 'Implementation [horz]' })
      vim.keymap.set('n', '[Vert]<C-]>', '<Cmd>vertical split | lua vim.lsp.buf.definition()<CR>',
        { desc = 'Definition [vert]' })
      vim.keymap.set('n', '[Vert]<C-g><C-]>', '<Cmd>vertical split | lua vim.lsp.buf.implementation<CR>',
        { desc = 'Implementation [vert]' })
      vim.keymap.set('n', '<C-t><C-]>', '<Cmd>tab split | lua vim.lsp.buf.definition()<CR>',
        { desc = 'Definition [tab]' })
      vim.keymap.set('n', '<C-t><C-g><C-]>', '<Cmd>tab split | lua vim.lsp.buf.implementation<CR>',
        { desc = 'Implementation [tab]' })
    end
  }
  use {
    'hrsh7th/nvim-cmp',
    requires = {
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/cmp-path' },
      { 'hrsh7th/cmp-cmdline' },
    },
    config = function()
      local cmp = require('cmp')
      local function close_and_fallback(fallback)
        if cmp.visible() then
          cmp.close()
        end
        fallback()
      end

      local function cmp_visible_or_fallback(action)
        return function(fallback)
          if cmp.visible() then
            action()
            return
          end
          fallback()
        end
      end

      cmp.setup({
        snippet = {
          -- REQUIRED - you must specify a snippet engine
          expand = function(args)
            -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
            require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
            -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
            -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = {
          ['<M-j>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
          ['<M-k>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
          ['<Tab>'] = cmp.mapping(function()
            if cmp.visible() then
              cmp.select_next_item()
            else
              cmp.complete()
            end
          end, { 'i', 'c' }),
          ['<M-Tab>'] = cmp.mapping(cmp_visible_or_fallback(cmp.select_prev_item), { 'i', 'c' }),
          ['<C-n>'] = cmp.mapping({
            i = cmp_visible_or_fallback(cmp.select_next_item),
            c = function(fallback)
              if cmp.visible() and cmp.get_active_entry() ~= nil then
                cmp.select_next_item()
              else
                fallback()
              end
            end,
          }),
          ['<C-p>'] = cmp.mapping({
            i = cmp_visible_or_fallback(cmp.select_prev_item),
            c = function(fallback)
              if cmp.visible() and cmp.get_active_entry() ~= nil then
                cmp.select_prev_item()
              else
                fallback()
              end
            end,
          }),
          ['<C-l>'] = cmp.mapping(function()
            if cmp.visible() then
              cmp.select_next_item()
            else
              cmp.complete({
                config = {
                  sources = {
                    { name = 'buffer' }
                  }
                }
              })
            end
          end, { 'i', 'c' }),
          ['<C-y>'] = cmp.mapping(cmp.mapping.confirm({ select = true }), { 'i', 'c' }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          ['<C-o>'] = cmp.mapping(cmp.mapping.confirm({ select = true }), { 'i', 'c' }),
          ['<C-a>'] = cmp.mapping(close_and_fallback, { 'i', 'c' }),
          ['<C-e>'] = cmp.mapping(close_and_fallback, { 'i', 'c' }),
          ['<C-g>'] = cmp.mapping(cmp.mapping.abort(), { 'i', 'c' }),
        },
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          -- { name = 'vsnip' }, -- For vsnip users.
          { name = 'luasnip' }, -- For luasnip users.
          -- { name = 'ultisnips' }, -- For ultisnips users.
          -- { name = 'snippy' }, -- For snippy users.
        }, {
          { name = 'buffer' },
        })
      })

      -- Set configuration for specific filetype.
      -- cmp.setup.filetype('gitcommit', {
      --   sources = cmp.config.sources({
      --     { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
      --   }, {
      --     { name = 'buffer' },
      --   })
      -- })

      -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline('/', {
        sources = {
          { name = 'buffer' }
        }
      })

      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline(':', {
        sources = cmp.config.sources({
          { name = 'path' }
        }, {
          { name = 'cmdline' }
        })
      })
    end
  }
  use {
    "ray-x/lsp_signature.nvim",
    config = function()
      require("lsp_signature").setup({
        hint_prefix = "🦆 "
      })
    end
  }
  use {
    'simrat39/rust-tools.nvim',
    ft = 'rust',
  }
  use {
    'L3MON4D3/LuaSnip',
    tag = "v1.*",
    requires = {
      { 'rafamadriz/friendly-snippets' },
      { 'saadparwaiz1/cmp_luasnip' },
    },
    config = function()
      require("luasnip").config.setup({ store_selection_keys = "<C-]>" })
      -- Both sources can be enabled at the same time
      local ls_vscode = require("luasnip.loaders.from_vscode")
      ls_vscode.lazy_load() -- enable LSP style snippets
      -- require("luasnip.loaders.from_snipmate").lazy_load()

      vim.keymap.set({ "i", "s" }, "<C-]>", "<Plug>luasnip-expand-or-jump")
      vim.keymap.set({ "i", "s" }, "<C-s>", "<Plug>luasnip-jump-next")
      vim.keymap.set({ "i", "s" }, "<M-s>", "<Plug>luasnip-jump-prev")
      vim.keymap.set("s", "<Tab>", "<Esc>i", { noremap = true })
      vim.keymap.set("s", "<C-a>", "<Esc>a", { noremap = true })

      vim.api.nvim_create_user_command('LuaSnipLoadSnippetsVSCode', ls_vscode.load, {})
    end
  }
  use {
    'nvim-treesitter/nvim-treesitter',
    config = function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = { "fennel", "fish", "go", "lua", "rust", "vim", "yaml" },
        highlight = {
          enable = true,
          -- disable = { "rust" },
        },
      })
      -- require('nvim-treesitter.highlight').set_custom_captures({
      --   operator = "Special",
      --   namespace = "TSNone",
      --   ["function"] = "Include",
      --   ["function.call"] = "TSFunction",
      --   ["function.builtin"] = "TSFunction",
      --   ["method"] = "Include",
      --   ["method.call"] = "TSMethod",
      --   variable = "Normal",
      --   parameter = "Normal",
      --   field = "TSNone", -- field of struct initialisation
      --   property = "TSNone", -- field of struct definition, but this affects the property after `.` like time.Second
      -- })
      vim.wo.foldmethod = 'expr'
      vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'
      vim.wo.foldlevel = 99
    end,
    run = ':TSUpdate',
  }
  use {
    'nvim-treesitter/nvim-treesitter-textobjects',
    config = function()
      require('nvim-treesitter.configs').setup({
        textobjects = {
          select = {
            keymaps = {
              ["ap"] = "@parameter.outer",
              ["ip"] = "@parameter.inner",
              ["ar"] = "@conditional.outer",
              ["ir"] = "@conditional.inner",
              ["al"] = "@loop.outer",
              ["il"] = "@loop.inner",
            },
          },
        }
      })
    end
  }
  use 'vim-utils/vim-husk'

  -- misc
  use {
    'folke/lsp-trouble.nvim',
    config = function()
      local trouble = require("trouble")
      trouble.setup({
        padding = false, -- add an extra new line on top of the list
        auto_close = true, -- automatically close the list when you have no diagnostics
        auto_preview = false, -- automatically preview the location of the diagnostic. <esc> to close preview and go back to last window
      })

      local function replace_qflist()
        vim.cmd('cclose')
        trouble.open("quickfix", "auto=true")
      end

      local function replace_loclist()
        vim.cmd('lclose')
        trouble.open("loclist", "auto=true")
      end

      require("which-key").register({
        ["<C-q>"] = {
          name = "Trouble",
          ["<C-q>"] = { function() trouble.toggle({ auto = true }) end, "Trouble toggle" },
          ["<C-r>"] = { "<Cmd>TroubleRefresh<CR>", "Trouble refresh" },
          ["<C-e>"] = { function() trouble.open("document_diagnostics", "auto=true") end, "Troube document diagnostics" },
          ["<C-w>"] = { function() trouble.open("workspace_diagnostics", "auto=true") end,
            "Trouble workspace diagnostics" },
          ["<C-f>"] = { function() replace_qflist() end, "Trouble quickfix" },
          ["<C-l>"] = { function() replace_loclist() end, "Trouble loclist" },
          ["<C-n>"] = { function() trouble.next({ skip_groups = true, jump = true }) end, "Trouble next" },
          ["<C-p>"] = { function() trouble.previous({ skip_groups = true, jump = true }) end, "Trouble previous" },
          ["<C-_>"] = { function() trouble.help() end, "Trouble keybind" },
          q = {
            name = "close",
            c = { "<Cmd>cclose<CR>", "cclose" },
            l = { "<Cmd>lclose<CR>", "lclose" },
          },
        },
      })

      -- Attempt to replace quickfix window with Trouble.
      -- With `BufWinEnter`, it ends up an error like `Not allowed to edit another buffer now`.
      -- With `WinNew` or `WinEnter`, passed buffer number as argument will not be of quickfix window.
      -- With `BufEnter`, passed buffer number is buffer number of quickfix window, but replace will not be performned
      -- local function replace_qflist_with_trouble(bufnr)
      --   print('bufnr: ' .. bufnr)
      --   local win_id = vim.fn.win_findbuf(bufnr)[1]
      --   local is_quickfx = vim.fn.getwininfo(win_id)[1]['quickfix'] == 1
      --   local is_loclist = vim.fn.getwininfo(win_id)[1]['loclist'] == 1
      --   if is_loclist then
      --     replace_loclist()
      --   elseif is_quickfx then
      --     replace_qflist()
      --   end
      -- end

      -- local trouble_hijack_qf_win = vim.api.nvim_create_augroup('trouble_hijack_qf_win', {})
      -- vim.api.nvim_create_autocmd('BufEnter', {
      -- vim.api.nvim_create_autocmd('WinEnter', {
      -- vim.api.nvim_create_autocmd('WinNew', {
      --   group = trouble_hijack_qf_win,
      --   pattern = '*',
      --   callback = function(info)
      --     print(vim.inspect(info))
      --     replace_qflist_with_trouble(info.buf)
      --   end
      -- })
    end
  }
  use {
    'ahmedkhalf/project.nvim',
    config = function()
      require("project_nvim").setup({
        show_hidden = false,
        patterns = { "Cargo.toml", ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json" },
      })
    end
  }
  use {
    'sheerun/vim-polyglot',
    -- setup = function()
    --   vim.g.polyglot_disabled = { 'markdown' }
    -- end,
  }
  use {
    'tpope/vim-abolish',
    config = function()
      vim.g.abolish_no_mappings = 1
    end
  }
  use {
    'vim-test/vim-test',
    disable = true,
    config = function()
      -- By default, tab is opened left to the current tab, and that makes
      -- closing the test tab focus the tab left to the original tab.
      -- `neovim` strategy opens the terminal tag right to the original tab.
      vim.g['test#neovim#term_position'] = 'tab'
      vim.g['test#strategy'] = 'neovim'
    end
  }
  use {
    "nvim-neotest/neotest",
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/neotest-go",
      "rouge8/neotest-rust",
    },
    config = function()
      local neotest_ns = vim.api.nvim_create_namespace("neotest")
      vim.diagnostic.config({
        virtual_text = {
          format = function(diagnostic)
            local message =
            diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
            return message
          end,
        },
      }, neotest_ns)
      require("neotest").setup({
        adapters = {
          require("neotest-go"),
          require("neotest-rust"),
          -- For reference
          -- require("neotest-vim-test")({
          --   ignore_file_types = { "python", "vim", "lua" },
          -- }),
        },
      })
      require('keymap.which-key-helper').register_with_editable('neotest', vim.g.chief_key .. 't', vim.g.chief_key, {
        { 't', 'lua require("neotest").run.run()', { desc = 'Test nearest' } },
        { 'T', 'lua require("neotest").run.run(vim.fn.expand("%"))', { desc = 'Test file' } },
        { 'o', 'lua require("neotest").output.open()', { desc = 'Open test output' } },
        { 'O', 'lua require("neotest").output.open({ enter = true })', { desc = 'Open test output and focus the window' } },
        { 'p', 'lua require("neotest").output_panel.toggle()', { desc = 'Toggle output panel' } },
        { 's', 'lua require("neotest").summary.toggle()', { desc = 'Toggle summary' } },
      })
      vim.keymap.set('n', '[n', '<cmd>lua require("neotest").jump.prev({})<CR>', { desc = "Jump to previous test" })
      vim.keymap.set('n', ']n', '<cmd>lua require("neotest").jump.next({})<CR>', { desc = "Jump to next test" })
    end,
  }
  use 'tyru/open-browser.vim'

  -- Language specific
  -- <go>
  use {
    'ray-x/go.nvim',
    ft = { 'go', 'gomod', 'gosum' },
    requires = { 'ray-x/guihua.lua', opt = true },
    config = function()
      require('go').setup({
        test_runner = 'richgo',
      })
      local go_format_augroud_id = vim.api.nvim_create_augroup('go_format', {})
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = go_format_augroud_id,
        pattern = '*.go',
        callback = function()
          require('go.format').goimport()
        end
      })
    end,
  }
  -- Language specific
  -- markup languages
  use({ 'jakewvincent/mkdnflow.nvim',
    -- rocks = 'luautf8', -- Ensures optional luautf8 dependency is installed
    config = function()
      require('mkdnflow').setup({
        modules = {
          bib = true,
          buffers = true,
          conceal = true,
          cursor = true,
          folds = true,
          links = true,
          lists = true,
          maps = false,
          paths = true,
          tables = true
        },
        links = {
          conceal = true,
        },
      })
    end
  })
  use {
    'AckslD/nvim-FeMaco.lua',
    config = function()
      require("femaco").setup()
    end,
  }
  --[[
  -- <fish>
  use 'dag/vim-fish'
  -- <js>
  use 'moll/vim-node'
  -- <java>
  if executable('java')
    use 'artur-shaik/vim-javacomplete2' -- complains if there is no java executable
  endif
  -- <php>
  if executable('composer')
    use 'phpactor/phpactor', {'branch': 'master', 'do': 'composer install --no-dev -o'}
  endif
  use 'rust-lang/rust.vim'
  use 'vim-php/tagbar-phpctags.vim'
  use 'stephpy/vim-php-cs-fixer'
  use 'noahfrederick/vim-laravel'
  -- <markdown>
  use 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }}
  use 'mzlogin/vim-markdown-toc'
  use 'dhruvasagar/vim-table-mode'
  -- <plantuml>
  use 'weirongxu/plantuml-previewer.vim'
  ]]


  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  else
    local compile_path = vim.fn.stdpath('config') .. '/plugin/packer_compiled.lua'
    if vim.fn.empty(vim.fn.glob(compile_path)) > 0 then
      require('packer').compile()
    end
  end
end)
