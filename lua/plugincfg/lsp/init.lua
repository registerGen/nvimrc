local M = {}

local function on_attach(client, bufnr)
  require('plugincfg.lsp.ui').on_attach(client, bufnr)
  require('aerial').on_attach(client, bufnr)
end

local server_config = {
  bashls = {},
  clangd = {},
  cssls = {},
  html = {},
  jedi_language_server = {},
  sumneko_lua = require('lua-dev').setup {
    lspconfig = {
      cmd = {
        vim.fn.stdpath 'data'
          .. '/lsp_servers/sumneko_lua/extension/server/bin/lua-language-server',
      },
      settings = {
        Lua = {
          completion = {
            showWord = 'Disable',
            workSpaceWord = false,
          },
        },
      },
    },
  },
  texlab = {
    cmd = { vim.fn.stdpath 'data' .. '/lsp_servers/latex/texlab' },
  },
  tsserver = {},
  vimls = {},
}

M.config = function()
  for server, config in pairs(server_config) do
    require('lspconfig')[server].setup(vim.tbl_deep_extend('force', {}, {
      capabilities = require('cmp_nvim_lsp').update_capabilities(
        vim.lsp.protocol.make_client_capabilities()
      ),
      on_attach = on_attach,
    }, config))
  end
end

return M
