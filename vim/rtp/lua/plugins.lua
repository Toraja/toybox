local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  packer_bootstrap = vim.fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

return require('packer').startup(function(use)
  --[[
    setup/config inside `requires` seems not working.
    Plugins which need configuraton but are only dependencies of another plugins
    must be marked as `-- dependency`
  ]]--
  use 'wbthomason/packer.nvim'
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
        cnoreabbrev gl Git log
        cnoreabbrev glg vertical sbuffer <Bar> Gllog
        cnoreabbrev gd Gvdiffsplit
        cnoreabbrev gp Git push
      ]])
      -- vim.g.fugitive_no_maps = 1 -- prevent <C-n/p> to be mapped
      vim.keymap.set('n', '<Leader>vs' , "<Cmd>tab Git<CR>", { desc = "vim-fugitive" })
      vim.keymap.set('n', '<Leader>vlt', "<Cmd>tab Git log<CR>", { desc = "git log [tab]" })
      vim.keymap.set('n', '<Leader>vlv', "<Cmd>vertical Git log<CR>", { desc = "git log [vert]" })
      vim.keymap.set('n', '<Leader>vB' , "<Cmd>Git blame<CR>", { desc = "git blame entire file" })
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
          end, {expr=true})

          map('n', '[c', function()
            if vim.wo.diff then return '[c' end
            vim.schedule(function() gs.prev_hunk() end)
            return '<Ignore>'
          end, {expr=true})

          -- Actions
          map({'n','x'}, '<leader>vhs', ':Gitsigns stage_hunk<CR>')
          map({'n','x'}, '<leader>vhr', ':Gitsigns reset_hunk<CR>')
          map('n', '<leader>vhu', gs.undo_stage_hunk)
          map('n', '<leader>vhS', gs.stage_buffer)
          map('n', '<leader>vhR', gs.reset_buffer)
          map('n', '<leader>vhp', gs.preview_hunk)
          map('n', '<leader>vhb', function() gs.blame_line{full=true} end)
          map('n', '<leader>vtb', gs.toggle_current_line_blame)
          map('n', '<leader>vhd', gs.diffthis)
          map('n', '<leader>vhD', function() gs.diffthis('~') end)
          map('n', '<leader>vtd', gs.toggle_deleted)

          -- Text object
          map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
        end
      })
    end
  }
  use {
    'zivyangll/git-blame.vim',
    config = function()
      vim.keymap.set('n', '<Leader>vb', "<Cmd>GitBlame<CR>", { desc = "git blame current line" })
    end
  }

  -- look & feel
  use {
    'nvim-lualine/lualine.nvim',
    -- nvim-web-devicons requires external font such as https://www.nerdfonts.com/
    requires = { 'kyazdani42/nvim-web-devicons', opt = true },
    config = function()
      local function section_c()
        local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ':~')
        local filepath = vim.fn.expand('%')
        return cwd .. ' | ' .. filepath
      end
      require('lualine').setup({
        options = { theme = 'ayu_mirage' },
        sections = {
          lualine_c = { section_c },
        },
      })
    end,
  }

  -- finder (path/dir/file/buffer/tac/etc.)
  use {
    'kyazdani42/nvim-tree.lua',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true },
    config = function()
      require("nvim-tree").setup ({
        hijack_netrw = false, -- let ranger hijack
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
          mappings = {
            list = {
              { key = "<C-e>", action = '' },
              { key = "H",     action = '' },
            },
          },
        },
        renderer = {
          highlight_opened_files = "all",
        },
      })
    end
  }
  use {
    -- dependency
    'rbgrouleff/bclose.vim',
    config = function()
      vim.g.bclose_no_plugin_maps = true
    end
  }
  use {
    'francoiscabrol/ranger.vim',
    requires = { 'rbgrouleff/bclose.vim' },
    cond = function() return vim.fn.executable('ranger') end,
    config = function()
      vim.g.ranger_map_keys = 0
      vim.g.ranger_replace_netrw = 1
      local wk = require("which-key")
      wk.register({
        e = {
          name = "Ranger",
          t = { "<Cmd>RangerCurrentFileNewTab<CR>", "Ranger [tab]" },
          v = { "<Cmd>call OpenRangerIn('%:p:h', 'vnew ')<CR>", "Ranger [vert]" },
          w = { "<Cmd>call OpenRangerIn('%:p:h', 'new ')<CR>", "Ranger [horz]" },
        },
      }, { prefix = "<Leader>" })
    end
  }
  use {
    'preservim/tagbar',
    config = function()
      vim.keymap.set('n', '<Leader>o', '<Cmd>TagbarToggle<CR>')
      vim.keymap.set('n', '<Leader>O', '<Cmd>TagbarOpen fj<CR>')
    end
  }
  use {
    'ibhagwan/fzf-lua',
    disable = true,
    requires = { 'kyazdani42/nvim-web-devicons', opt = true },
    config = function()
      local wk = require("which-key")
      local fzf = require('fzf-lua')
      fzf.setup {
        winopts = {
          preview = {
            horizontal = 'right:50%',     -- right|left:size
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
      function fzf_lua_ghq()
        local fzf = require('fzf-lua')
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
    end
  }
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.0',
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
      telescope.setup{
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
          layout_config={
            prompt_position = "top",
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
              ["<C-d>"] = { "<DEL>", type = "command" },
              ["<C-u>"] = { "<C-u>", type = "command" },
              ["<M-j>"] = function(bufnr) action_set.scroll_previewer(bufnr, 0.5) end,
              ["<M-k>"] = function(bufnr) action_set.scroll_previewer(bufnr, -0.5) end,
            },
          },
        },
        pickers = {
          -- Default configuration for builtin pickers goes here:
          find_files = {
            find_command = {"fd", "--type", "f", "--hidden", "--exclude", ".git"},
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
      }
      telescope.load_extension('fzf')
      telescope.load_extension('ghq')
      telescope.load_extension("packer")
    end,
  }

  -- moving around
  use {
    'phaazon/hop.nvim',
    config = function()
      local hop = require('hop')
      hop.setup{
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
          hint_offset = 1, -- XXX this stops 1 char before the specified char
        })
      end
      vim.keymap.set({'n','x','o'}, 'f', "<Cmd>HopChar1CurrentLineAC<CR>")
      vim.keymap.set({'n','x','o'}, 'F', "<Cmd>HopChar1CurrentLineBC<CR>")
      vim.keymap.set({'n','x','o'}, 'sw', "<Cmd>HopWordAC<CR>")
      vim.keymap.set({'n','x','o'}, 'sb', "<Cmd>HopWordBC<CR>")
      vim.keymap.set({'n','x','o'}, 'sj', "<Cmd>HopLineAC<CR>")
      vim.keymap.set({'n','x','o'}, 'sk', "<Cmd>HopLineBC<CR>")
      vim.keymap.set({'n','x','o'}, 's/', "<Cmd>HopPatternAC<CR>")
      vim.keymap.set({'n','x','o'}, 's?', "<Cmd>HopPatternBC<CR>")
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
      vim.keymap.set('n', 'yx', 'yaI\']p', { remap = true, desc = 'Yank lines with the parent indent block and paste below the block' })
    end
  }
  use {
    'jeetsukumaran/vim-indentwise',
    config = function()
      vim.keymap.set ({'n','x','o'}, '{', '<Plug>(IndentWisePreviousEqualIndent)', { desc = 'Previous equal indent' })
      vim.keymap.set ({'n','x','o'}, '}', '<Plug>(IndentWiseNextEqualIndent)', { desc = 'Next equal indent' })
    end
  }
  use {
    'bkad/CamelCaseMotion',
    config = function()
      vim.keymap.set({'n','x','o'}, '<M-w>', '<Plug>CamelCaseMotion_w', { silent = true })
      vim.keymap.set({'n','x','o'}, '<M-b>', '<Plug>CamelCaseMotion_b', { silent = true })
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
      vim.keymap.set({'n','x','o'}, 'p'    , '<Plug>(miniyank-autoput)'  )
      vim.keymap.set({'n','x','o'}, 'P'    , '<Plug>(miniyank-autoPut)'  )
      vim.keymap.set({'n','x','o'}, '<M-p>', '<Plug>(miniyank-cycle)'    )
      vim.keymap.set({'n','x','o'}, '<M-P>', '<Plug>(miniyank-cycleback)')
    end,
  }
  use 'editorconfig/editorconfig-vim'
  use {
    'lukas-reineke/indent-blankline.nvim',
    config = function()
      vim.cmd [[highlight IndentBlanklineChar ctermfg=59]]
      vim.cmd [[highlight IndentBlanklineSpaceChar None]] -- highlight overlaps cursorline. set None to prevent it.

      require("indent_blankline").setup {
        char = "¦",
        show_first_indent_level = false,
        filetype_exclude = { 'markdown', 'vimwiki', 'json', 'nerdtree', 'NvimTree', 'man' }
      }
    end,
  }
  use {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup({
        ignore = '^$',
      })
      -- XXX not working
      -- vim.keymap.set('i', '<C-\\>', '<C-o>gcc', { remap = true, silent = true } )
    end
  }
  use {
    'preservim/nerdcommenter',
    disable = true,
    config = function()
      vim.g.NERDSpaceDelims = 1 -- Add spaces after comment delimiters
      vim.g.NERDDefaultAlign = 'left'
      vim.keymap.set({'n','x', 'i'}, '<C-\\>', '<Plug>NERDCommenterToggle')
    end
  }
  use 'arthurxavierx/vim-caser'
  use {
    'tpope/vim-surround',
    -- set characters and correspondng wrappers
    -- value for variable have to be surrounded by "", not ''
    -- pre-defined mappings that are useful are:
    -- t: "<[tag]>\r</[tag]>" <- [tag] will be replaced by user input
    -- f: "[function](\r)" <- [function] will be replaced by user input
    config = function()
      vim.g.surround_no_mappings = 1
      vim.g.surround_100 = "${\r}"    -- d
      vim.g.surround_68 = "\"${\r}\"" -- D
      vim.g.surround_115 = "$(\r)"    -- s
      vim.g.surround_83 = "\"$(\r)\"" -- S
      vim.keymap.set('n', 'dr',  '<Plug>Dsurround')
      vim.keymap.set('n', 'cr',  '<Plug>Csurround')
      vim.keymap.set('n', 'cR',  '<Plug>CSurround')
      vim.keymap.set('n', 'yr',  '<Plug>Ysurround')
      vim.keymap.set('n', 'yR',  '<Plug>YSurround')
      vim.keymap.set('n', 'yrr', '<Plug>Yssurround')
      vim.keymap.set('n', 'yRR', '<Plug>YSsurround')
      vim.keymap.set('x', 'R',   '<Plug>VSurround')
      vim.keymap.set('x', 'gR',  '<Plug>VgSurround')
    end,
  }
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
      vim.g.AutoPairsMapSpace = 0   -- Enabling this maps <Space> to <C-]><C-R>=... and <C-]> is unwanted
      vim.g.AutoPairsMultilineClose = 0
      vim.keymap.set('i', '<Space>', '<C-g>u<C-r>=AutoPairsSpace()<CR>', { silent = true })
    end,
  }
  use 'AndrewRadev/splitjoin.vim'
  use 'tpope/vim-repeat'
  use 'junegunn/vim-easy-align'
  -- somehow neomake#configure#automake() is not found
  -- use {
  --   'neomake/neomake',
  --   config = function()
  --     vim.g.neomake_open_list = 2
  --     vim.cmd([[
  --       try
  --         call neomake#configure#automake('w')
  --       catch /^Vim\%((\a\+)\)\=:E117/
  --         " The function does not exist. Ignore it.
  --       endtry
  --     ]])
  --   end
  -- }
  use {
    'neovim/nvim-lspconfig',
    config = function()
      -- 'java': [$HOME.'/toybox/vim/helper/java-lsp.sh', '-data', getcwd()],
      -- 'javascript': ['typescript-language-server', '--stdio'],
      -- 'php': [s:plugin_dir . '/phpactor/bin/phpactor', 'language-server'],
      -- 'python': [executable('/usr/local/bin/pyls') ? '/usr/local/bin/pyls' : $HOME.'/.local/bin/pyls'],

      vim.cmd([[highlight link NormalFloat Normal]])
      -- vim.lsp.set_log_level("debug")

      local lspconfig = require('lspconfig')
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
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

      local servers = { 'gopls', 'rust_analyzer' }
      for _, lsp in pairs(servers) do
        lspconfig[lsp].setup ({
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

      vim.keymap.set('i', '<C-g><C-h>', '<Cmd>lua vim.lsp.buf.signature_help()<CR>', { desc = 'Signature help' })
      vim.keymap.set('n', '<C-]>',  '<Cmd>lua vim.lsp.buf.definition()<CR>', { desc = 'Definition' })
      vim.keymap.set('n', 'g<C-]>', '<Cmd>lua vim.lsp.buf.implementation<CR>', { desc = 'Implementation' })
      vim.keymap.set('n', '<C-w><C-]>', '<Cmd>split | lua vim.lsp.buf.definition()<CR>', { desc = 'Definition [horz]' })
      vim.keymap.set('n', '<C-w><C-g><C-]>', '<Cmd>split | lua vim.lsp.buf.implementation<CR>', { desc = 'Implementation [horz]' })
      vim.keymap.set('n', '[Vert]<C-]>', '<Cmd>vertical split | lua vim.lsp.buf.definition()<CR>', { desc = 'Definition [vert]' })
      vim.keymap.set('n', '[Vert]<C-g><C-]>', '<Cmd>vertical split | lua vim.lsp.buf.implementation<CR>', { desc = 'Implementation [vert]' })
      vim.keymap.set('n', '<C-t><C-]>', '<Cmd>tab split | lua vim.lsp.buf.definition()<CR>', { desc = 'Definition [tab]' })
      vim.keymap.set('n', '<C-t><C-g><C-]>', '<Cmd>tab split | lua vim.lsp.buf.implementation<CR>', { desc = 'Implementation [tab]' })
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
          ['<Tab>'] = cmp.mapping(function(fallback)
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
          ['<C-l>'] = cmp.mapping(function(fallback)
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
    'simrat39/rust-tools.nvim',
    ft = 'rust',
  }
  use {
    'L3MON4D3/LuaSnip',
    requires = {
      { 'rafamadriz/friendly-snippets' },
      { 'saadparwaiz1/cmp_luasnip' },
    },
    config = function()
      require("luasnip").config.setup({store_selection_keys="<C-]>"})
      -- Both sources can be enabled at the same time
      local ls_vscode = require("luasnip.loaders.from_vscode")
      ls_vscode.lazy_load() -- enable LSP style snippets
      -- require("luasnip.loaders.from_snipmate").lazy_load()

      vim.keymap.set({"i", "s"}, "<C-]>", "<Plug>luasnip-expand-or-jump")
      vim.keymap.set({"i", "s"}, "<C-s>", "<Plug>luasnip-jump-next")
      vim.keymap.set({"i", "s"}, "<M-s>", "<Plug>luasnip-jump-prev")
      vim.keymap.set("s", "<Tab>", "<Esc>i", { noremap = true })
      vim.keymap.set("s", "<C-a>", "<Esc>a", { noremap = true })

      vim.api.nvim_create_user_command('LuaSnipLoadSnippetsVSCode', ls_vscode.load, {})
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
      require("which-key").register({
        ["<C-q>"] = {
          name = "Trouble",
          ["<C-q>"] = { function() trouble.toggle({ auto = true }) end, "Trouble toggle" },
          ["<C-r>"] = { "<Cmd>TroubleRefresh<CR>", "Trouble refresh" },
          ["<C-e>"] = { function() trouble.open("document_diagnostics", "auto=true") end, "Troube document diagnostics" },
          ["<C-w>"] = { function() trouble.open("workspace_diagnostics", "auto=true") end, "Trouble workspace diagnostics" },
          ["<C-f>"] = { function() trouble.open("quickfix", "auto=true") end, "Trouble quickfix" },
          ["<C-l>"] = { function() trouble.open("loclist", "auto=true") end, "Trouble loclist" },
          ["<C-n>"] = { function() trouble.next({skip_groups = true, jump = true}) end, "Trouble next" },
          ["<C-p>"] = { function() trouble.previous({skip_groups = true, jump = true}) end, "Trouble previous" },
        },
      })
      -- Attempt to replace quickfix window with Trouble.
      -- This ends up an error like `Not allowed to edit another buffer now`.
      -- local function replace_qflist_with_trouble()
      --   if vim.o.buftype ~= 'quickfix' then
      --     return
      --   end
      --   local is_loclist = vim.fn.getwininfo(vim.fn.win_getid())[1]['loclist'] == 1
      --   if is_loclist then
      --     lclose
      --     vim.cmd('Trouble loclist')
      --   else
      --     cclose
      --     vim.cmd('Trouble quickfix')
      --   end
      -- end
      -- vim.api.nvim_create_user_command('TroubleHijackQfWin', replace_qflist_with_trouble, {})
      -- vim.cmd([[
      --   augroup trouble_hijack_qf_win
      --     autocmd!
      --     autocmd BufWinEnter * TroubleHijackQfWin
      --   augroup END
      -- ]])
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
  use 'sheerun/vim-polyglot'
  use {
    'tpope/vim-abolish',
    config = function()
      vim.g.abolish_no_mappings = 1
    end
  }
  use {
    'vim-test/vim-test',
    config = function()
      -- By default, tab is opened left to the current tab, and that makes
      -- closing the test tab focus the tab left to the original tab.
      -- The below configuration opens the test right to the original tab.
      vim.g['test#neovim#term_position'] = 'tab'
      vim.g['test#strategy'] = 'neovim'
    end
  }
  use 'tyru/open-browser.vim'

  --[[
  -- Language specific
  -- <fish>
  use 'dag/vim-fish'
  -- <js>
  use 'moll/vim-node'
  -- <go>
  use 'fatih/vim-go', { 'tag': '*' } -- Do not run `GoUpdateBinaries` post-hook as it takes a long time
  use 'ctrlpvim/ctrlp.vim'   -- required by vim-go GoDecls
  -- disable the default mapping to prevent from <C-p> to be overridden
  let g:ctrlp_map = '<F13>'
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
  -- <wiki>
  use 'vimwiki/vimwiki'
  -- <markdown>
  use 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }}
  use 'mzlogin/vim-markdown-toc'
  use 'dhruvasagar/vim-table-mode'
  -- <plantuml>
  use 'weirongxu/plantuml-previewer.vim'
  ]]--


  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)
