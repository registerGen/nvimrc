local M = {}

M.config = function()
  local cmp = require 'cmp'

  cmp.setup {
    snippet = {
      expand = function(args)
        vim.fn['vsnip#anonymous'](args.body)
      end,
    },
    sources = cmp.config.sources {
      { name = 'nvim_lsp' },
      { name = 'nvim_lsp_signature_help' },
      { name = 'vsnip' },
      { name = 'path' },
    },
    mapping = cmp.mapping.preset.insert {
      ['<C-j>'] = cmp.mapping(cmp.mapping.scroll_docs(3)),
      ['<C-k>'] = cmp.mapping(cmp.mapping.scroll_docs(-3)),
      ['<Tab>'] = cmp.mapping.confirm { select = true },
    },
    formatting = {
      format = require('lspkind').cmp_format {
        mode = 'symbol_text',
        maxwidth = 60,
      },
    },
    window = {
      documentation = {
        border = 'rounded',
      },
    },
  }

  for _, v in ipairs { '/', '?' } do
    cmp.setup.cmdline(v, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = 'buffer' },
      },
    })
  end

  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources {
      { name = 'cmdline' },
    },
  })
end

return M
