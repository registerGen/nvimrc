local M = {}

local aerial = require 'aerial'

local tobool = function(x)
  if x ~= 0 then
    return true
  else
    return false
  end
end

-- Utility function to comment/uncomment config = ... in plugins.lua
M.comment_config = function()
  local plugins_path = vim.fn.stdpath 'config' .. '/lua/plugins.lua'
  if not tobool(vim.fn.filereadable(plugins_path)) then
    vim.notify(
      'plugins.lua not found',
      vim.log.levels.ERROR,
      { title = 'utils.lua::comment_config' }
    )
    return
  end
  if vim.fn.expand '%:p' ~= plugins_path then
    return
  end

  for index = 1, vim.fn.line '$' do
    local content = vim.fn.getline(index)
    vim.cmd(':' .. tostring(index))
    -- config = function() .. end
    if vim.regex([[config = function()]]):match_str(content) then
      vim.cmd 'normal j'
      vim.cmd 'normal vafgc'
    end
  end
end

M.uncomment_config = function()
  local plugins_path = vim.fn.stdpath 'config' .. '/lua/plugins.lua'
  if not tobool(vim.fn.filereadable(plugins_path)) then
    vim.notify(
      'plugins.lua not found',
      vim.log.levels.ERROR,
      { title = 'utils.lua::comment_config' }
    )
    return
  end
  if vim.fn.expand '%:p' ~= plugins_path then
    return
  end

  local last = false
  for index = 1, vim.fn.line '$' do
    local content = vim.fn.getline(index)
    vim.cmd(':' .. tostring(index))
    -- config = function() .. end
    if vim.regex([[-- config = function\(\)]]):match_str(content) then
      last = true
      vim.cmd 'normal gcc'
    else
      if last == true and vim.regex([[--]]):match_str(content) then
        vim.cmd 'normal gcc'
      else
        last = false
      end
    end
  end
end

return M
