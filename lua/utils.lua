local M = {}

local aerial = require 'aerial'

-- Winbar

-- Format the list representing the symbol path
-- Grab it from https://github.com/stevearc/aerial.nvim/blob/master/lua/lualine/components/aerial.lua
local function format_symbols(symbols, depth, separator, icons_enabled)
  local parts = {}
  depth = depth or #symbols

  if depth > 0 then
    symbols = { unpack(symbols, 1, depth) }
  else
    symbols = { unpack(symbols, #symbols + 1 + depth) }
  end

  for _, symbol in ipairs(symbols) do
    if icons_enabled then
      table.insert(parts, string.format('%s %s', symbol.icon, symbol.name))
    else
      table.insert(parts, symbol.name)
    end
  end

  return table.concat(parts, separator)
end

M.winbar = function()
  -- Get a list representing the symbol path by aerial.get_location (see
  -- https://github.com/stevearc/aerial.nvim/blob/master/lua/aerial/init.lua#L127),
  -- and format the list to get the symbol path.
  -- Grab it from
  -- https://github.com/stevearc/aerial.nvim/blob/master/lua/lualine/components/aerial.lua#L89
  local symbols = aerial.get_location(true)
  local symbol_path = format_symbols(symbols, nil, ' ❯ ', true)

  return '%F ❯ ' .. (symbol_path == '' and '...' or symbol_path)
end

-- Utility function to comment/uncomment config = ... in plugins.lua
M.comment_config = function()
  local plugins_path = vim.fn.stdpath 'config' .. '/lua/plugins.lua'
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
