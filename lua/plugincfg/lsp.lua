local M = {}

local function on_attach(client, bufnr)
  require('keymaps').register_prefix 'lsp'
  local rk = require('keymaps').register_keymap
  rk('lsp', 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', 'Hover doc', bufnr)
  rk('lsp', 'n', 'c', '<cmd>lua vim.lsp.buf.code_action()<CR>', 'Code action', bufnr)
  rk('lsp', 'n', 'D', '<cmd>lua vim.diagnostic.open_float(nil, { focus = false })<CR>', 'Show diagnostics', bufnr)
  rk('lsp', 'n', 'd', '<cmd>lua require(\'goto-preview\').goto_preview_definition()<CR>', 'Go to definition', bufnr)
  rk('lsp', 'n', 'f', '<cmd>lua vim.lsp.buf.format({ async = false })<CR>', 'Formatting', bufnr)
  rk(
    'lsp',
    'n',
    'i',
    '<cmd>lua require(\'goto-preview\').goto_preview_implementation()<CR>',
    'Go to implementation',
    bufnr
  )
  rk('lsp', 'n', 'r', '<cmd>lua require(\'goto-preview\').goto_preview_references()<CR>', 'Go to references', bufnr)
  rk('lsp', 'n', 'n', '<cmd>lua vim.lsp.buf.rename()<CR>', 'Symbol renaming', bufnr)

  require('aerial').on_attach(client, bufnr)

  local id = vim.api.nvim_create_augroup('LspDocumentHighlight', { clear = true })
  vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
    group = id,
    buffer = bufnr,
    callback = function()
      vim.lsp.buf.document_highlight()
    end,
  })
  vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
    group = id,
    buffer = bufnr,
    callback = function()
      vim.lsp.buf.clear_references()
    end,
  })
end

local server_config = {
  bashls = {},
  clangd = {},
  cssls = {},
  html = {},
  jedi_language_server = {},
  sumneko_lua = require('lua-dev').setup {
    lspconfig = {
      cmd = { vim.fn.stdpath 'data' .. '/lsp_servers/sumneko_lua/extension/server/bin/lua-language-server' },
    },
  },
  texlab = {
    cmd = { vim.fn.stdpath 'data' .. '/lsp_servers/latex/texlab' },
  },
  tsserver = {},
  vimls = {},
}

M.config = function()
  vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    update_in_insert = true,
    virtual_text = { spacing = 4, prefix = '●' },
    severity_sort = true,
  })

  local signs = { Error = '', Warn = '', Info = '', Hint = '' }
  for type, icon in pairs(signs) do
    local hl = 'DiagnosticSign' .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  end

  local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
  function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
    opts = opts or {}
    opts.border = 'rounded'
    return orig_util_open_floating_preview(contents, syntax, opts, ...)
  end

  for server, config in pairs(server_config) do
    require('lspconfig')[server].setup(vim.tbl_deep_extend('force', {}, {
      capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities()),
      on_attach = on_attach,
    }, config))
  end
end

return M
