local utils = require('utils')

-- Command for utils/(un)comment_config()
local commented = false
local function comment_config_toggle()
  if commented == false then
    utils.comment_config()
    commented = true
  else
    utils.uncomment_config()
    commented = false
  end
end

vim.api.nvim_create_user_command('CommentConfigToggle', comment_config_toggle, {})
