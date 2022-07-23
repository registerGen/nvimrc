local M = {}
M.config = function()
  local configuration = vim.fn['sonokai#get_configuration']()
  local palette = vim.fn['sonokai#get_palette'](configuration.style, configuration.colors_override)

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
    winbar = {
      lualine_b = { { 'filetype', icon_only = true }, { 'filename', path = 3 } },
      lualine_c = { { 'aerial', sep = ' ❯ ' } },
      lualine_z = { '%{strftime(\'%c\')}' }
    },
    inactive_winbar = {
      lualine_b = { { 'filetype', icon_only = true }, { 'filename', path = 3 } },
    },
    extensions = { 'nvim-tree', 'fugitive', 'aerial' },
  }
end

return M
