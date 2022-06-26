local opt = vim.opt

opt.background = 'dark'
opt.backup = false
opt.completeopt = { 'menu', 'menuone', 'noselect' }
opt.cursorline = true
opt.cmdheight = 0
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
opt.winbar = '%{%v:lua.require(\'utils\').winbar()%}'
opt.wrap = false

vim.g.tex_flavor = 'latex'
vim.g.do_filetype_lua = 1
vim.g.did_load_filetypes = 0
