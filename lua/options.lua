local opt = vim.opt

opt.background = 'dark'
opt.backup = false
opt.completeopt = { 'menu', 'menuone', 'noselect' }
opt.cursorline = true
opt.expandtab = true
opt.foldexpr = 'nvim_treesitter#foldexpr()'
opt.foldlevel = 100000
opt.foldmethod = 'expr'
opt.ignorecase = true
opt.laststatus = 3
opt.list = true
opt.listchars:append 'eol:↴'
opt.mouse = 'a'
opt.number = true
opt.relativenumber = true
opt.shiftwidth = 2
opt.signcolumn = 'number'
opt.smartcase = true
opt.splitbelow = true
opt.splitright = true
opt.swapfile = false
opt.tabstop = 2
opt.termguicolors = true
opt.timeoutlen = 500
opt.updatetime = 500
opt.wrap = false

vim.g.tex_flavor = 'latex'

local disabled_builtins = {
  '2html_plugin',
  'getscript',
  'getscriptPlugin',
  'gzip',
  'logipat',
  'man',
  'matchit',
  'netrwFileHandlers',
  'netrwPlugin',
  'netrwSettings',
  'rrhelper',
  'spellfile_plugin',
  'tar',
  'tarPlugin',
  'vimball',
  'vimballPlugin',
  'zip',
  'zipPlugin',
}

for _, plugin in ipairs(disabled_builtins) do
  vim.g['loaded_' .. plugin] = 1
end
