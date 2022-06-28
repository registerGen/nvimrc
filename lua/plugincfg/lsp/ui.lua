local M = {}

M.on_attach = function(_, bufnr)
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

  -- Show LSP Progress
  -- Utility functions shared between progress reports for LSP and DAP

  local client_notifs = {}

  local function get_notif_data(client_id, token)
    if not client_notifs[client_id] then
      client_notifs[client_id] = {}
    end

    if not client_notifs[client_id][token] then
      client_notifs[client_id][token] = {}
    end

    return client_notifs[client_id][token]
  end

  local spinner_frames = { '⣾', '⣽', '⣻', '⢿', '⡿', '⣟', '⣯', '⣷' }

  local function update_spinner(client_id, token)
    local notif_data = get_notif_data(client_id, token)

    if notif_data.spinner then
      local new_spinner = (notif_data.spinner + 1) % #spinner_frames
      notif_data.spinner = new_spinner

      notif_data.notification = vim.notify(nil, nil, {
        hide_from_history = true,
        icon = spinner_frames[new_spinner],
        replace = notif_data.notification,
      })

      vim.defer_fn(function()
        update_spinner(client_id, token)
      end, 100)
    end
  end

  local function format_title(title, client_name)
    return client_name .. (#title > 0 and ': ' .. title or '')
  end

  local function format_message(message, percentage)
    return (percentage and percentage .. '%\t' or '') .. (message or '')
  end

  -- LSP integration
  -- Make sure to also have the snippet with the common helper functions in your config!

  vim.lsp.handlers['$/progress'] = function(_, result, ctx)
    local client_id = ctx.client_id

    local val = result.value

    if not val.kind then
      return
    end

    local notif_data = get_notif_data(client_id, result.token)

    if val.kind == 'begin' then
      local message = format_message(val.message, val.percentage)

      notif_data.notification = vim.notify(message, 'info', {
        title = format_title(val.title, vim.lsp.get_client_by_id(client_id).name),
        icon = spinner_frames[1],
        timeout = false,
        hide_from_history = false,
      })

      notif_data.spinner = 1
      update_spinner(client_id, result.token)
    elseif val.kind == 'report' and notif_data then
      notif_data.notification = vim.notify(format_message(val.message, val.percentage), 'info', {
        replace = notif_data.notification,
        hide_from_history = false,
      })
    elseif val.kind == 'end' and notif_data then
      notif_data.notification = vim.notify(val.message and format_message(val.message) or 'Complete', 'info', {
        icon = '',
        replace = notif_data.notification,
        timeout = 3000,
      })

      notif_data.spinner = nil
    end
  end
end

return M
