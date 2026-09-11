local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "isort", "black" },

    -- Web Development (Stop after first available: prettierd OR prettier)
    javascript = { "prettierd", "prettier", stop_after_first = true },
    typescript = { "prettierd", "prettier", stop_after_first = true },
    typescriptreact = { "prettierd", "prettier", stop_after_first = true },
    javascriptreact = { "prettierd", "prettier", stop_after_first = true },
    json = { "prettierd", "prettier", stop_after_first = true },
    jsonc = { "prettierd", "prettier", stop_after_first = true },
    html = { "prettierd", "prettier", stop_after_first = true },
    css = { "prettierd", "prettier", stop_after_first = true },
    scss = { "prettierd", "prettier", stop_after_first = true },
    markdown = { "prettierd", "prettier", stop_after_first = true },
    yaml = { "prettierd", "prettier", stop_after_first = true },

    -- Others
    go = { "gofmt" },
    c = { "clang_format" },
    cpp = { "clang_format" },
  },

  format_on_save = {
    -- 500ms was too tight: a formatter's first exec after install pays a
    -- macOS quarantine check and silently times out, so saves stop formatting
    -- with no error. This is a ceiling, not a delay.
    timeout_ms = 2000,
    -- lsp_fallback is deprecated; lsp_format is the current key.
    lsp_format = "fallback",
  },
}

return options
