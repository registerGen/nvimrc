local M = {}

M.config = function()
  local palette = vim.fn['sonokai#get_palette']('default', vim.empty_dict())

  require('lualine').setup {
    options = {
      globalstatus = true,
    },
    sections = {
      lualine_b = {
        'branch',
        'diff',
        {
          'diagnostics',
          sources = { 'nvim_diagnostic' },
          symbols = { error = '', warn = '', info = '', hint = '' },
          update_in_insert = true,
          diagnostics_color = {
            error = { fg = palette.red[1] },
            warn = { fg = palette.yellow[1] },
            info = { fg = palette.blue[1] },
            hint = { fg = palette.green[1] },
          },
        },
      },
      lualine_x = { 'filesize', 'encoding', 'fileformat', 'filetype' },
    },
    extensions = { 'nvim-tree', 'fugitive', 'aerial' },
  }
end

return M
