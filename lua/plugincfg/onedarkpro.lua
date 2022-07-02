local M = {}

M.config = function()
  local onedarkpro = require 'onedarkpro'
  onedarkpro.setup {
    options = {
      bold = true,
      italic = true,
      underline = true,
      undercurl = true,
      cursorline = true,
      window_unfocussed_color = true,
    },
  }
  onedarkpro.load()
end

return M
