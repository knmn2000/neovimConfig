return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        cspell_ls = {
          root_dir = require("lspconfig.util").root_pattern(".git", "package.json", "cspell.json"),
          filetypes = { "javascript", "typescript", "lua", "python", "markdown" },
        },
      },
    },
  },
}
