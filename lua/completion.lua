-- ~/.config/nvim/lua/completion.lua

-- Setup nvim-cmp.
local cmp = require "cmp"

cmp.setup {
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
  mapping = {
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.close(),
    ["<CR>"] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ["<Alt-Space>"] = cmp.mapping.complete(), -- Map Alt+Space to trigger completion
  },
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
  }, {
    { name = "buffer" },
  }),
}

-- Use buffer source for `/`.
cmp.setup.cmdline("/", {
  sources = {
    { name = "buffer" },
  },
})

-- Use cmdline & path source for ':'.
cmp.setup.cmdline(":", {
  sources = cmp.config.sources({
    { name = "path" },
  }, {
    { name = "cmdline" },
  }),
})

-- Setup lspconfig.
local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
local lspconfig = require "lspconfig"

-- HTML
lspconfig.html.setup {
  capabilities = capabilities,
}

-- CSS
lspconfig.cssls.setup {
  capabilities = capabilities,
}

lspconfig.tsserver.setup {
  capabilities = capabilities,
}

lspconfig.pyright.setup {
  capabilities = capabilities,
}
