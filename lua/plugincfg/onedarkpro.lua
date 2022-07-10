local M = {}

M.config = function()
  if false then
    require('ondarkpro').setup {
      options = {
        bold = true,
        italic = true,
        underline = true,
        undercurl = true,
        cursorline = true,
        window_unfocussed_color = true,
      },
    }
  end
end

return M
