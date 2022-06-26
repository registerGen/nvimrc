local M = {}

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

M.prefix = {
  bufferline = '<leader>b',
  coderunner = '<leader>c',
  hop = '<leader>h',
  lsp = '<leader>l',
  nvimtree = '<leader>n',
  playground = '<leader>p',
  telescope = '<leader>t',
  visualmulti = '<leader>v',
}

M.register_prefix = function(plugin_name, prefix, prefix_name)
  if prefix == nil then
    require('which-key').register {
      [M.prefix[plugin_name]] = { name = '+[' .. plugin_name .. ']' },
    }
  else
    require('which-key').register {
      [M.prefix[plugin_name] .. prefix] = { name = '+[' .. plugin_name .. '] ' .. prefix_name },
    }
  end
end

M.register_keymap = function(plugin_name, mode, lhs, rhs, desc, bufnr, opts)
  opts = opts or {}
  opts.noremap = true
  opts.silent = true
  if bufnr == nil then
    vim.api.nvim_set_keymap(mode, M.prefix[plugin_name] .. lhs, rhs, opts)
    require('which-key').register {
      [M.prefix[plugin_name] .. lhs] = { rhs, '[' .. plugin_name .. '] ' .. desc },
    }
  else
    vim.api.nvim_buf_set_keymap(bufnr, mode, M.prefix[plugin_name] .. lhs, rhs, opts)
    require('which-key').register({
      [M.prefix[plugin_name] .. lhs] = { rhs, '[' .. plugin_name .. '] ' .. desc },
    }, { buffer = bufnr })
  end
end

return M
