local M = {}

M.config = function()
  for _, config in pairs(require('nvim-treesitter.parsers').get_parser_configs()) do
    config.install_info.url =
      config.install_info.url:gsub('https://github.com/', 'https://ghproxy.com/github.com/')
  end

  require('nvim-treesitter.configs').setup {
    ensure_installed = 'all',
    auto_install = true,
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = 'gnn',
        node_incremental = 'grn',
        scope_incremental = 'grc',
        node_decremental = 'grm',
      },
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['as'] = '@class.outer',
          ['is'] = '@class.inner',
          ['ac'] = '@conditional.outer',
          ['ic'] = '@conditional.inner',
          ['al'] = '@loop.outer',
          ['il'] = '@loop.inner',
        },
      },
      swap = {
        enable = false,
      },
      move = {
        enable = true,
        set_jumps = true,
        goto_next_start = {
          [']m'] = '@function.outer',
          [']]'] = '@class.outer',
        },
        goto_next_end = {
          [']M'] = '@function.outer',
          [']['] = '@class.outer',
        },
        goto_previous_start = {
          ['[m'] = '@function.outer',
          ['[['] = '@class.outer',
        },
        goto_previous_end = {
          ['[M'] = '@function.outer',
          ['[]'] = '@class.outer',
        },
      },
    },
    rainbow = {
      enable = true,
      extended_mode = true,
      max_file_lines = nil,
    },
    playground = {
      enable = true,
      disable = {},
      updatetime = 25,
      persist_queries = false,
    },
    endwise = {
      enable = true,
    },
  }

  require('keymaps').register_prefix 'playground'
  local rk = require('keymaps').register_keymap
  rk('playground', 'n', 't', '<cmd>TSPlaygroundToggle<CR>', 'Toggle treesitter playground')
  rk('playground', 'n', 'h', '<cmd>TSHighlightCapturesUnderCursor<CR>', 'Show highlight group')
end

return M
