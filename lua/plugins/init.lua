return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    opts = require "configs.conform",
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  -- AI Assistant (Avante)
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false, 
    build = "make",
    opts = {
      provider = "gpt-5.2",
      auto_suggestions_provider = "gpt-5.2",
      -- NEW: "vendors" is now "providers"
      providers = {
        ["gpt-5.2"] = {
          __inherited_from = "openai",
          model = "gpt-5.2", -- Removed "-codex" to fix the Chat endpoint error
          timeout = 30000,
          -- NEW: Model parameters moved here to stop deprecation warnings
          extra_request_body = {
            temperature = 0,
            max_completion_tokens= 20480, -- Increased for better code generation
          },
        },
      },
    },
    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
      "nvim-treesitter/nvim-treesitter",
      {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = { file_types = { "markdown", "Avante" } },
        ft = { "markdown", "Avante" },
      },
    },
  },
}
