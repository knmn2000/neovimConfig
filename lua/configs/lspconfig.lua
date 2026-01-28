require("nvchad.configs.lspconfig").defaults()

-- Added 'vtsls' (the better typescript lsp), 'eslint', and 'tailwindcss'
local servers = { "html", "cssls", "clangd", "gopls", "pyright", "vtsls", "eslint", "tailwindcss" }

-- This enables the servers and handles the default NvChad setup
vim.lsp.enable(servers)
