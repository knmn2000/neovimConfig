return {
  -- Telescope: show .env and other gitignored/hidden files in find_files (<leader>ff)
  {
    "nvim-telescope/telescope.nvim",
    opts = function(_, opts)
      opts = opts or {}
      opts.pickers = opts.pickers or {}
      opts.pickers.find_files = vim.tbl_deep_extend("force", opts.pickers.find_files or {}, {
        no_ignore = true,
        hidden = true,
      })
      return opts
    end,
  },

  -- Override nvim-tree: hide dotfiles but always show .env files
  {
    "nvim-tree/nvim-tree.lua",
    opts = {
      filters = {
        dotfiles = true,
        custom = {},
        exclude = { "%.env", "%.env%.local", "%.env%." },
      },
    },
  },

  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    opts = require "configs.conform",
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      require("nvchad.configs.lspconfig").defaults()

      -- Use modern Neovim 0.11+ API
      local mingw_bin = "C:/Users/Admin/AppData/Local/Microsoft/WinGet/Packages/"
        .. "BrechtSanders.WinLibs.POSIX.UCRT_Microsoft.Winget.Source_8wekyb3d8bbwe/mingw64/bin"
      vim.lsp.config("clangd", {
        cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--header-insertion=never",
          "--offset-encoding=utf-16",
          "--query-driver=" .. mingw_bin .. "/g*.exe",
        },
        root_dir = vim.fs.root(0, { ".git", "compile_commands.json", "compile_flags.txt", ".clangd" }),
      })

      vim.lsp.enable "clangd"

      require "configs.lspconfig"
    end,
  },
  -- AI Assistant (Avante)
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false,
    build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false",
    opts = {
      provider = "gpt-5.2",
      auto_suggestions_provider = "gpt-5.2",
      behaviour = {
        auto_suggestions = true,
      },
      providers = {
        ["gpt-5.2"] = {
          __inherited_from = "openai",
          model = "gpt-5.2",
          timeout = 30000,
          extra_request_body = {
            temperature = 0,
            max_completion_tokens = 20480,
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

  -- Neogit
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
    },
    cmd = "Neogit",
    keys = {
      { "<leader>gg", function() require("neogit").open({ kind = "vsplit" }) end, desc = "Neogit (vertical)" },
    },
    opts = {
      integrations = { diffview = true },
    },
  },
}
