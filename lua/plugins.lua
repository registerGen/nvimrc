require('packer').init {
  display = {
    open_fn = function()
      return require('packer.util').float { border = 'rounded' }
    end,
    prompt_border = 'rounded',
  },
  git = {
    default_url_format = 'https://ghproxy.com/https://github.com/%s',
  },
}

require('packer').startup(function(use)
  -- Plugin Manager {{{1
  use 'wbthomason/packer.nvim'

  -- Colorscheme {{{1
  use {
    'sainnhe/sonokai',
    config = function()
      vim.g.sonokai_enable_italic = 1
      vim.g.sonokai_diagnostic_text_highlight = 1
      vim.g.sonokai_diagnostic_virtual_text = 'colored'
      vim.g.sonokai_disable_terminal_colors = 1

      local id = vim.api.nvim_create_augroup('Sonokai', { clear = true })
      vim.api.nvim_create_autocmd('ColorScheme', {
        group = id,
        pattern = 'sonokai',
        callback = function()
          local palette = vim.fn['sonokai#get_palette']('default', vim.empty_dict())
          vim.fn['sonokai#highlight']('TSParameter', palette.orange, palette.none, 'italic')
          vim.fn['sonokai#highlight']('TSParameterReference', palette.orange, palette.none, 'italic')
          vim.fn['sonokai#highlight']('CmpItemAbbrDeprecated', palette.grey, palette.none)
        end,
      })
      vim.cmd 'colors sonokai'
    end,
  }

  -- LSP {{{1
  use {
    'williamboman/nvim-lsp-installer',
    config = function()
      require('nvim-lsp-installer').setup {
        github = {
          download_url_template = 'https://ghproxy.com/https://github.com/%s/releases/download/%s/%s',
        },
      }
    end,
  }
  use {
    'neovim/nvim-lspconfig',
    config = require('plugincfg.lsp').config(),
  }
  use {
    'kosayoda/nvim-lightbulb',
    config = function()
      require('nvim-lightbulb').setup {
        sign = {
          priority = 100,
        },
      }

      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        callback = function()
          require('nvim-lightbulb').update_lightbulb()
        end,
      })
    end,
  }
  use {
    'rmagatti/goto-preview',
    config = function()
      require('goto-preview').setup {
        border = { '🢄', '─', '╮', '│', '╯', '─', '╰', '│' },
      }
    end,
  }
  use {
    'stevearc/aerial.nvim',
    config = function()
      require('aerial').setup {
        backends = { 'lsp', 'treesitter', 'markdown' },
      }
    end,
  }

  -- Completion {{{1
  use {
    'hrsh7th/nvim-cmp',
    config = require('plugincfg.cmp').config(),
  }
  use {
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-nvim-lsp-signature-help',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/cmp-vsnip',
    after = 'nvim-cmp',
  }
  use 'onsails/lspkind-nvim'

  -- Markdown {{{1
  use {
    'iamcco/markdown-preview.nvim',
    run = 'cd app && yarn install',
    ft = 'markdown',
    config = function()
      local id = vim.api.nvim_create_augroup('MarkdownPreview', { clear = true })
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'markdown',
        group = id,
        command = 'MarkdownPreview',
      })
      vim.g.mkdp_highlight_css = vim.fn.stdpath 'config' .. '/utils/solarized_dark.css'
      vim.g.mkdp_markdown_css = vim.fn.stdpath 'config' .. '/utils/github.css'
      vim.g.mkdp_theme = 'dark'
    end,
  }

  -- Syntax {{{1
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = require('plugincfg.treesitter').config(),
  }
  use {
    'nvim-treesitter/nvim-treesitter-textobjects',
    after = 'nvim-treesitter',
  }
  use {
    'nvim-treesitter/playground',
    after = 'nvim-treesitter',
  }
  use {
    'm-demare/hlargs.nvim',
    after = 'nvim-treesitter',
    config = function()
      require('hlargs').setup {
        highlight = { link = 'TSParameter' },
      }
    end,
  }

  -- Snippet {{{1
  use {
    'hrsh7th/vim-vsnip',
    config = function()
      vim.g.vsnip_snippet_dir = vim.fn.stdpath 'config' .. '/vsnip'

      vim.api.nvim_set_keymap(
        'i',
        '<C-j>',
        'vsnip#jumpable(1)  ? \'<Plug>(vsnip-jump-next)\' : \'<C-j>\'',
        { expr = true }
      )
      vim.api.nvim_set_keymap(
        's',
        '<C-j>',
        'vsnip#jumpable(1)  ? \'<Plug>(vsnip-jump-next)\' : \'<C-j>\'',
        { expr = true }
      )
      vim.api.nvim_set_keymap(
        'i',
        '<C-k>',
        'vsnip#jumpable(-1) ? \'<Plug>(vsnip-jump-prev)\' : \'<C-j>\'',
        { expr = true }
      )
      vim.api.nvim_set_keymap(
        's',
        '<C-k>',
        'vsnip#jumpable(-1) ? \'<Plug>(vsnip-jump-prev)\' : \'<C-j>\'',
        { expr = true }
      )
    end,
  }

  -- Fuzzy Finder {{{1
  use {
    'nvim-telescope/telescope.nvim',
    requires = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
    },
    config = function()
      require('telescope').load_extension 'fzf'
      require('telescope').load_extension 'aerial'
    end,
  }

  -- Color {{{1
  use {
    'norcalli/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup()
    end,
  }

  -- Utility {{{1
  use {
    'rcarriga/nvim-notify',
    config = function()
      require('notify').setup {
        stages = 'fade',
        icons = {
          WARN = '',
        },
      }

      vim.notify = require 'notify'
    end,
  }
  use 'stevearc/dressing.nvim'
  use 'antoinemadec/FixCursorHold.nvim'

  -- Neovim Lua Development {{{1
  use 'folke/lua-dev.nvim'
  use 'milisims/nvim-luaref'

  -- Tabline {{{1
  use {
    'akinsho/bufferline.nvim',
    requires = { 'kyazdani42/nvim-web-devicons' },
    config = require('plugincfg.bufferline').config(),
  }

  -- Statusline {{{1
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons' },
    config = require('plugincfg.lualine').config(),
  }

  -- Startup {{{1
  use 'dstein64/vim-startuptime'
  use {
    'glepnir/dashboard-nvim',
    config = function()
      local board = require 'dashboard'
      board.custom_header = {
        '',
        '',
        '',
        '',
        '',
        '███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗',
        '████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║',
        '██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║',
        '██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║',
        '██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║',
        '╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝',
        '',
        '',
      }
      board.custom_center = {
        {
          icon = '  ',
          desc = 'Recently opened files                   ',
          action = 'Telescope oldfiles',
        },
        {
          icon = '  ',
          desc = 'Find File                               ',
          action = 'Telescope find_files find_command=rg,--hidden,--files',
        },
        {
          icon = '  ',
          desc = 'Find word                               ',
          action = 'Telescope live_grep',
        },
      }
      board.hide_statusline = false
      board.hide_tabline = false
    end,
  }
  use 'lewis6991/impatient.nvim'

  -- Indent {{{1
  use {
    'lukas-reineke/indent-blankline.nvim',
    config = function()
      require('indent_blankline').setup {
        char = '▏',
        show_current_context = true,
        show_current_context_start = true,
        context_char = '▎',
        filetype_exclude = { 'lspinfo', 'packer', 'checkhealth', 'help', 'lsp-installer', 'dashboard', '' },
        buftype_exclude = { 'nofile', 'terminal' },
      }
    end,
  }

  -- File Explorer {{{1
  use {
    'kyazdani42/nvim-tree.lua',
    requires = { 'kyazdani42/nvim-web-devicons' },
    config = function()
      require('nvim-tree').setup {
        diagnostics = {
          enable = true,
        },
      }

      require('keymaps').register_prefix 'nvimtree'
      local rk = require('keymaps').register_keymap
      rk('nvimtree', 'n', 't', '<cmd>NvimTreeToggle<CR>', 'Toggle nvim-tree')
    end,
  }

  -- Git {{{1
  use 'tpope/vim-fugitive'
  use {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup()
    end,
  }
  use 'f-person/git-blame.nvim'

  -- Comment {{{1
  use {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end,
  }

  -- Motion {{{1
  use {
    'ggandor/leap.nvim',
    requires = { 'tpope/vim-repeat' },
    config = function()
      require('leap').set_default_keymaps()
    end
  }

  -- Code Runner {{{1
  use {
    'CRAG666/code_runner.nvim',
    requires = 'nvim-lua/plenary.nvim',
    config = function()
      require('code_runner').setup {
        startinsert = true,
        filetype = {
          cpp = 'cd $dir && ' .. vim.fn.stdpath 'config' .. '/utils/run_cpp.sh $fileName $fileNameWithoutExt',
          python = 'cd $dir && python $fileName',
          tex = 'cd $dir && latexmk $fileName && latexmk -c && evince -f $fileNameWithoutExt.pdf',
        },
      }

      require('keymaps').register_prefix 'coderunner'
      local rk = require('keymaps').register_keymap
      rk('coderunner', 'n', 'r', '<cmd>RunCode<CR>', 'Run code')
    end,
  }

  -- Editing Support {{{1
  use {
    'windwp/nvim-autopairs',
    config = function()
      require('nvim-autopairs').setup()
    end,
  }
  use {
    'windwp/nvim-ts-autotag',
    config = function()
      require('nvim-ts-autotag').setup()
    end,
  }
  use {
    'p00f/nvim-ts-rainbow',
    after = 'nvim-treesitter',
  }
  use {
    'nvim-treesitter/nvim-treesitter-context',
    after = 'nvim-treesitter',
    config = function()
      require('treesitter-context').setup()
    end,
  }
  use {
    'mg979/vim-visual-multi',
    config = function()
      vim.g.VM_leader = require('keymaps').prefix['visualmulti']

      require('keymaps').register_prefix 'visualmulti'
    end,
  }
  use 'matze/vim-move'
  use 'RRethy/nvim-treesitter-endwise'

  -- Formatting {{{1
  use {
    'cappyzawa/trim.nvim',
    config = function()
      require('trim').setup()
    end
  }

  -- Keybinding {{{1
  use {
    'folke/which-key.nvim',
    config = function()
      require('which-key').setup()
    end,
  }

  --- }}}1
end)

-- vim:fdm=marker:fdl=0
