local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "isort", "black" },
    javascript = { { "prettierd", "prettier" } },
    typescript = { { "prettierd", "prettier" } },
    typescriptreact = { { "prettierd", "prettier" } },
    javascriptreact = { { "prettierd", "prettier" } },
    json = { { "prettierd", "prettier" } },
    jsonc = { { "prettierd", "prettier" } },
    html = { { "prettierd", "prettier" } },
    css = { { "prettierd", "prettier" } },
    scss = { { "prettierd", "prettier" } },
    markdown = { { "prettierd", "prettier" } },
    yaml = { { "prettierd", "prettier" } },
    go = { "gofmt", "goimports" },
    c = { "clang_format" },
    cpp = { "clang_format" },
    sql = { "sqlfmt" },
    -- css = { "prettier" },
    -- html = { "prettier" },
  },
  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = true,
  },

  -- format_on_save = {
  --   -- These options will be passed to conform.format()
  --   timeout_ms = 500,
  --   lsp_fallback = true,
  -- },
}

return options
