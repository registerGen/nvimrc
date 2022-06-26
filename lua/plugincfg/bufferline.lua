local M = {}

M.config = function()
  require('bufferline').setup {
    options = {
      diagnostics = 'nvim_lsp',
      diagnostics_update_in_insert = true,
      diagnostics_indicator = function(_, _, diagnostics_dict, _)
        local result = ''
        for severity, count in pairs(diagnostics_dict) do
          if severity == 'error' then
            result = result .. ''
          end
          if severity == 'warning' then
            result = result .. ''
          end
          if severity == 'info' then
            result = result .. ''
          end
          if severity == 'hint' then
            result = result .. ''
          end
          result = result .. count .. ' '
        end
        return result
      end,
      offsets = {
        {
          filetype = 'NvimTree',
          text = 'File Explorer',
          highlight = 'Directory',
          text_align = 'left',
        },
      },
    },
  }

  require('keymaps').register_prefix 'bufferline'
  require('keymaps').register_prefix('bufferline', 'c', 'Cycle')
  require('keymaps').register_prefix('bufferline', 'm', 'Move')
  local rk = require('keymaps').register_keymap
  rk('bufferline', 'n', 'mn', '<cmd>BufferLineMoveNext<CR>', 'Move next')
  rk('bufferline', 'n', 'mN', '<cmd>BufferLineMovePrev<CR>', 'Move previous')
  rk('bufferline', 'n', 'mp', '<cmd>BufferLineMovePrev<CR>', 'Move previous')
  rk('bufferline', 'n', 'cn', '<cmd>BufferLineCycleNext<CR>', 'Cycle next')
  rk('bufferline', 'n', 'cN', '<cmd>BufferLineCyclePrev<CR>', 'Cycle previous')
  rk('bufferline', 'n', 'cp', '<cmd>BufferLineCyclePrev<CR>', 'Cycle previous')
end

return M
