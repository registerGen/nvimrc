local M = {}

M.config = function()
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
      vim.fn['sonokai#highlight']('WinBar', palette.fg, palette.bg3, 'bold')
      vim.fn['sonokai#highlight']('WinBarNC', palette.grey, palette.bg3, 'bold')
    end,
  })
  vim.cmd 'colors sonokai'
end

return M
