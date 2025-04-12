-- Cribbing from https://vonheikemen.github.io/devlog/tools/build-your-first-lua-config-for-neovim/

-- Set a local variable to cut down on warnings about undefined global 'vim'.
vim = vim


--------------------------------------
-- Generic vim options and settings --
--------------------------------------


-- show line numbers
vim.opt.number = true

-- enable mouse support
vim.opt.mouse = 'a'

-- lines wrap
vim.opt.wrap = true
-- wrapped lines keep indentation
vim.opt.breakindent = true

-- newlines automatically match the previous level of indentation
vim.opt.autoindent = true
-- the tab key actually inserts spaces
vim.opt.expandtab = true
-- the tab key inserts two spaces
vim.opt.tabstop = 2
-- adjusting indentation increments by two spaces
vim.opt.shiftwidth = 2

-- use the system clipboard for the copy buffer
vim.cmd('set clipboard+=unnamedplus')

-- set the leader key
vim.g.mapleader = ' '

-- vertical splits for help
vim.cmd(':cabbrev h vert h')
vim.cmd(':cabbrev help vert help')


------------------------------------
-- Neovide specific configuration --
------------------------------------


if vim.fn.exists('g:neovide') then
  -- vim.opt.guifont = 'Cousine'
  vim.o.guifont = 'Cousine Nerd Font'
  vim.g.neovide_hide_mouse_when_typing = true
  vim.g.neovide_scroll_animation_length = 0.1
  vim.opt.title = true
  vim.opt.titlestring = vim.env.PWD

  Zoom = 0
  local function zoom_by(delta)
    Zoom = Zoom + delta
    vim.g.neovide_scale_factor = (1.1 ^ Zoom)
  end
  vim.keymap.set("n", "<C-=>", function()
    zoom_by(1)
  end)
  vim.keymap.set("n", "<C-->", function()
    zoom_by(-1)
  end)
end

--------------------------------
-- Keyboard shortcuts/hotkeys --
--------------------------------


-- save shortcut
vim.keymap.set('n', '<leader>w', '<cmd>write<cr>', { desc = 'Save' })
vim.keymap.set({ '', 'i', 'c' }, '<C-s>', '<cmd>write<cr>', { desc = 'Save' })

-- toggle nvim-tree
vim.keymap.set('n', '<leader>a', '<cmd>NvimTreeToggle<cr>', { desc = 'Toggle nvim-tree' })

-- switch tabs
vim.keymap.set({ '', 'c' }, '<S-Tab>', '<cmd>bp<cr>', { desc = 'Previous buffer' })
vim.keymap.set({ '', 'c' }, '<Tab>', '<cmd>bn<cr>', { desc = 'Next buffer' })

-- go fast
vim.keymap.set({ '', 'i', 'c' }, '<C-L>', 'w', {})
vim.keymap.set({ '', 'i', 'c' }, '<C-J>', '<C-D>', {})
vim.keymap.set({ '', 'i', 'c' }, '<C-K>', '<C-U>', {})
vim.keymap.set({ '', 'i', 'c' }, '<C-H>', 'b', {})

-- switch windows
vim.keymap.set('n', '<S-H>', '<c-W>h', { desc = 'Left window' })
vim.keymap.set('n', '<S-J>', '<C-W>j', { desc = 'Down window' })
vim.keymap.set('n', '<S-K>', '<c-W>k', { desc = 'Up window' })
vim.keymap.set('n', '<S-L>', '<C-W>l', { desc = 'Right window' })
-- split window
vim.keymap.set('n', '<C-W>v', '<cmd>vsplit<cr>', { desc = 'Split window vertically' })
vim.keymap.set('n', '<C-W>h', '<cmd>split<cr>', { desc = 'Split window horizontally' })
-- close window
vim.keymap.set('n', '<leader>q', ':q<cr>', { desc = 'Close window' })

-- close buffer
vim.keymap.set('n', '<leader>x', ':Bdelete<cr>', { desc = 'Close buffer' })
vim.keymap.set('n', '<leader>z', ':%bd|e#|bd#<cr>|\'"', { desc = 'Close all other buffers' })

-- Telescope
vim.keymap.set('n', '<C-p>', '<cmd>Telescope find_files<cr>', { desc = 'Open a file picker' })
vim.keymap.set('n', '<C-f>', '<cmd>Telescope live_grep<cr>', { desc = 'Search files for text' })

-- hop
vim.keymap.set('', '<leader>h', '<cmd>HopWordCurrentLineBC<cr>',
  { desc = 'Hop to a word before the cursor on the same line' })
vim.keymap.set('', '<leader>j', '<cmd>HopWordAC<cr>', { desc = 'Hop to a word after the cursor' })
vim.keymap.set('', '<leader>k', '<cmd>HopWordBC<cr>', { desc = 'Hop to a word before the cursor' })
vim.keymap.set('', '<leader>l', '<cmd>HopWordCurrentLineAC<cr>',
  { desc = 'Hop to a word after the cursor on the current line' })

-- comment/uncomment
-- linewise commenting
vim.keymap.set({ 'n', 'i', 'c' }, '<C-/>', function()
  require('Comment.api').toggle.linewise.current()
end, { desc = 'Toggle comments' })
vim.keymap.set('v', '<C-/>', function()
  local esc = vim.api.nvim_replace_termcodes('<ESC>', true, false, true)
  vim.api.nvim_feedkeys(esc, 'nx', false)
  require('Comment.api').toggle.linewise(vim.fn.visualmode())
end, { desc = 'Toggle comments' })

-- coverage
vim.keymap.set('', '<leader>cc', ':Coverage<cr>', { desc = 'Load and show coverage report' })
vim.keymap.set('', '<leader>cs', ':CoverageShow<cr>', { desc = 'Show coverage report' })
vim.keymap.set('', '<leader>ch', ':CoverageHide<cr>', { desc = 'Hide coverage report' })
vim.keymap.set('', '<leader>c', ':CoverageSummary<cr>', { desc = 'Show coverage report summary' })

-- format on save
-- vim.cmd([[autocmd BufWritePre * lua vim.lsp.buf.format({ async = false })]])
local format_buffer = function()
  vim.lsp.buf.format({ async = false })
end
FormatOnSave = false
local toggle_format = function()
  FormatOnSave = not (FormatOnSave)
  -- refresh the status line on the bottom
  require('lualine').refresh()
end
local attempt_format_on_save = function()
  if FormatOnSave then
    format_buffer()
  end
end
-- this will trigger on every file save
vim.api.nvim_create_autocmd('BufWritePre', { pattern = '*', callback = attempt_format_on_save })
-- toggle format on save
vim.keymap.set('', '<leader>g', toggle_format, { desc = 'Toggle format on save' })
vim.keymap.set('', '<leader>f', format_buffer, { desc = 'Format current buffer' })

-- search for word under cursor
local search_for_word = ':/<c-r>=expand("<cword>")<cr>'
vim.keymap.set('', '"', search_for_word, { desc = 'Search for word under cursor' })
local global_search_for_word = '<cmd>Telescope grep_string<cr>'
vim.keymap.set('', '<leader>"', global_search_for_word, { desc = 'Search all files for word under cursor' })
local replace_word = ':%s/<c-r>=expand("<cword>")<cr>/'
vim.keymap.set('', '<leader><leader>"', replace_word, { desc = 'Replace word under cursor' })


--------------------------
-- Diagnostics settings --
--------------------------


-- LSP Diagnostics Options Setup
local sign = function(opts)
  vim.fn.sign_define(opts.name, {
    texthl = opts.name,
    text = opts.text,
    numhl = ''
  })
end

sign({ name = 'DiagnosticSignError', text = '' })
sign({ name = 'DiagnosticSignWarn', text = '' })
sign({ name = 'DiagnosticSignHint', text = '' })
sign({ name = 'DiagnosticSignInfo', text = '' })

vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  update_in_insert = true,
  underline = true,
  severity_sort = false,
  float = {
    border = 'rounded',
    source = 'always',
    header = '',
    prefix = '',
  },
})

-- automatically open diagnostic info on cursor hover
vim.cmd([[
set signcolumn=yes
autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
]])
-- lower the cursor hover time from 4s to 1s
vim.opt.updatetime = 1000

--Set completeopt to have a better completion experience
-- :help completeopt
-- menuone: popup even when there's only one match
-- noinsert: Do not insert text until a selection is made
-- noselect: Do not select, force to select one from the menu
-- shortness: avoid showing extra messages when using completion
-- updatetime: set updatetime for CursorHold
vim.opt.completeopt = { 'menuone', 'noselect', 'noinsert', 'preview' }
vim.opt.shortmess = vim.opt.shortmess + { c = true }


------------------
-- Lazy Plugins --
------------------

-- install script
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- .editorconfig file support
  'editorconfig/editorconfig-vim',

  -- Enhanced window closing ability
  'moll/vim-bbye',

  -- nerd icons
  {
    'glepnir/nerdicons.nvim',
    cmd = 'NerdIcons',
    config = function() require('nerdicons').setup({}) end
  },
  -- Show buffers as tabs along the top of the screen
  {
    'akinsho/bufferline.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('bufferline').setup({
        options = {
          offsets = { { filetype = "NvimTree", padding = 0, separator = true } },
          separator_style = "slant"
        },
        highlights = {
          buffer_selected = {
            italic = false,
          },
        },
      })
    end
  },

  -- A color scheme like VSCodes
  { 'martinsione/darkplus.nvim', config = function() vim.cmd('colorscheme darkplus') end },

  -- Comment/uncomment commands
  -- hotkeys are defined in the hotkeys section
  {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup({
        mappings = false,
      })
    end
  },

  ---------------------
  -- Code completion --
  ---------------------

  -- Completion framework:
  {
    'hrsh7th/nvim-cmp',
    config = function()
      local cmp = require 'cmp'
      cmp.setup({
        -- Enable LSP snippets
        snippet = {
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
          end,
        },
        mapping = {
          ['<C-k>'] = cmp.mapping.select_prev_item(),
          ['<C-j>'] = cmp.mapping.select_next_item(),
          -- Add tab support
          ['<S-Tab>'] = cmp.mapping.select_prev_item(),
          ['<Tab>'] = cmp.mapping.select_next_item(),
          ['<C-S-f>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.close(),
          ['<CR>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
          })
        },
        -- Installed sources:
        sources = {
          { name = 'path' },                                       -- file paths
          { name = 'nvim_lsp',               keyword_length = 3 }, -- from language server
          { name = 'nvim_lsp_signature_help' },                    -- display function signatures with current parameter emphasized
          { name = 'nvim_lua',               keyword_length = 2 }, -- complete neovim's Lua runtime API such vim.lsp.*
          { name = 'buffer',                 keyword_length = 2 }, -- source current buffer
          { name = 'vsnip',                  keyword_length = 2 }, -- nvim-cmp source for vim-vsnip
          { name = 'calc' },                                       -- source for math calculation
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        formatting = {
          fields = { 'menu', 'abbr', 'kind' },
          format = function(entry, item)
            local menu_icon = {
              nvim_lsp = 'λ',
              vsnip = '⋗',
              buffer = 'Ω',
              path = '🖫',
            }
            item.menu = menu_icon[entry.source.name]
            return item
          end,
        },
      })
    end
  },

  -- LSP completion source:
  'hrsh7th/cmp-nvim-lsp',

  -- Useful completion sources:
  'hrsh7th/cmp-nvim-lua',
  'hrsh7th/cmp-nvim-lsp-signature-help',
  'hrsh7th/cmp-path',
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-vsnip',
  'hrsh7th/vim-vsnip',

  -- Git indicators
  { 'lewis6991/gitsigns.nvim',   config = [[ require('gitsigns').setup() ]] },

  -- Hop
  {
    'phaazon/hop.nvim',
    -- fixes a bug where trying to hop up/down on an empty line crashes
    commit = 'caaccee',
    -- branch = 'v2', -- optional but strongly recommended
    config = function()
      require('hop').setup({ keys = 'etovxqpdygfblzhckisuran' })
    end
  },

  -- Nicer bottom status bar
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      -- disable the default vim footer
      vim.opt.showmode = false
      -- custom widget to show if format on save is on
      local function fos_line()
        if FormatOnSave then
          return 'Format on Save'
        else
          return ''
        end
      end
      -- custom widget to show the zoom level
      local function zoom_line()
        if vim.g.neovide_scale_factor ~= 1.0 then
          return (tostring(math.floor(vim.g.neovide_scale_factor * 100)) .. '%%')
        else
          return ''
        end
      end
      -- custom widget to show the active virtual environment
      local function venv_line()
        if require('venv-selector').source() == nil then
          return ''
        else
          return 'venv on'
        end
      end
      require('lualine').setup({
        options = {
          theme = 'onedark',
          icons_enabled = true,
          component_separators = '|',
          section_separators = '',
        },
        sections = {
          lualine_x = { fos_line, zoom_line, venv_line, 'filetype' }
        },
      })
    end,
  },

  -- Mason, manages Language Server Protocol provider installation
  -- See the various :MasonInstall commands
  { 'williamboman/mason.nvim',  config = [[ require('mason').setup() ]] },
  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = { 'williamboman/mason.nvim' },
    config = function()
      require('mason-lspconfig').setup()
      local on_attach = function(client, bufnr)
        local bufopts = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set('n', '<leader>n', require('rust-tools').hover_actions.hover_actions, bufopts)
        vim.keymap.set('n', '<leader>m', require('rust-tools').code_action_group.code_action_group, bufopts)
        vim.keymap.set('n', '<leader>i', vim.lsp.buf.implementation, bufopts)
      end
      require('mason-lspconfig').setup_handlers({
        function(server_name)
          -- Rust LSP support is handled specially using rust-tools
          if server_name == 'rust_analyzer' then
            require("rust-tools").setup({
              server = {
                on_attach = on_attach,
                settings = {
                  ["rust-analyzer"] = {
                    -- clippy check on save
                    checkOnSave = {
                      command = "clippy",
                    },
                  },
                },
              },
            })
          elseif server_name == 'kotlin_language_server' then
            require('lspconfig')[server_name].setup({
              on_attach = on_attach,
              settings = {
                kotlin = {
                  compiler = {
                    jvm = {
                      target = "17"
                    }
                  }
                }
              }
            })
          else
            require("lspconfig")[server_name].setup({
              on_attach = on_attach
            })
          end
        end,
      })
    end,
  },
  { 'neovim/nvim-lspconfig',    dependencies = { 'williamboman/mason-lspconfig.nvim' } },
  { 'simrat39/rust-tools.nvim', dependencies = { 'williamboman/mason-lspconfig.nvim' } },

  -- Nvim-tree, a file browser
  'nvim-tree/nvim-web-devicons',
  {
    'nvim-tree/nvim-tree.lua',
    config = function()
      require('nvim-tree').setup({
        hijack_cursor = true,
        sync_root_with_cwd = true,
        actions = {
          open_file = {
            quit_on_open = true,
          },
        },
        filters = {
          dotfiles = false,
        },
        git = {
          ignore = false,
        },
      })
    end,
  },

  -- Telescope, a file/anything search utility
  {
    'nvim-telescope/telescope.nvim',
    version = '0.1.5',
    dependencies = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope-fzf-native.nvim' },
    config = function()
      require('telescope').setup({
        extensions = {
          fzf = {
            fuzzy = true,                   -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true,    -- override the file sorter
            case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
          }
        },
        -- sadly there is some kind of race condition where treesitter tries to do cleanup on the preview buffer after it has been partially cleaned up which throws errors whenever the file picker is closed.
        -- For now, preview must be disabled.
        defaults = {
          preview = false,
        },
      })
      require('telescope').load_extension('fzf')
    end
  },
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make',
    -- config = [[ require('telescope').load_extension('fzf') ]],
  },


  -- Treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = { "javascript", "json", "lua", "markdown", "python", "rust", "toml", "typescript" },
        auto_install = true,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        ident = { enable = true },
        rainbow = {
          enable = true,
          extended_mode = true,
          max_file_lines = nil,
        }
      }
    end
  },

  -- Test coverage
  {
    'andythigpen/nvim-coverage',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('coverage').setup()
    end,
  },

  -- Plenary
  'nvim-lua/plenary.nvim',

  -- venv-selector
  {
    'linux-cultist/venv-selector.nvim',
    dependencies = { 'neovim/nvim-lspconfig', 'nvim-telescope/telescope.nvim' },
    branch = 'regexp',
    event = 'VeryLazy', -- Optional: needed only if you want to type `:VenvSelect` without a keymapping
    keys = {
      -- Keymap to open VenvSelector to pick a venv.
      { '<leader>vs', '<cmd>VenvSelect<cr>' },
      -- Keymap to retrieve the venv from a cache (the one previously used for the same project directory).
      { '<leader>vc', '<cmd>VenvSelectCached<cr>' },
    },
    config = function()
      require('venv-selector').setup {
        settings = {
          search = {
            netbox = {
              command = "echo /opt/netbox/venv/bin/python"
            }
          }
        }
      }
    end,
  },
})
