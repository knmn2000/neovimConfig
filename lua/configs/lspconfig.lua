-- Single source of truth for LSP. Called once, from the nvim-lspconfig spec
-- in lua/plugins/init.lua.
--
-- NvChad's defaults() installs the shared capabilities (incl. the
-- resolveSupport.additionalTextEdits that makes completion auto-imports work),
-- the LspAttach keymaps, and enables lua_ls.
require("nvchad.configs.lspconfig").defaults()

-- ---------------------------------------------------------------------------
-- TypeScript / JavaScript (React, Next, Nest, Express, Node) via vtsls
-- ---------------------------------------------------------------------------
-- vtsls reads typescript.* and javascript.* as separate namespaces, so the
-- editor-behaviour keys have to be mirrored or JS buffers get the defaults.
local ts_prefs = {
  suggest = {
    completeFunctionCalls = true, -- complete the call signature, not just the name
  },
  preferences = {
    includePackageJsonAutoImports = "auto",
    importModuleSpecifier = "shortest",
  },
  updateImportsOnFileMove = { enabled = "always" },
  inlayHints = {
    parameterNames = { enabled = "literals" },
    functionLikeReturnTypes = { enabled = true },
    propertyDeclarationTypes = { enabled = true },
  },
}

vim.lsp.config("vtsls", {
  settings = {
    vtsls = {
      autoUseWorkspaceTsdk = true, -- respect the repo's own typescript version
      enableMoveToFileCodeAction = true,
      experimental = {
        completion = {
          enableServerSideFuzzyMatch = true,
          entriesLimit = 200,
        },
      },
    },
    typescript = vim.tbl_deep_extend("force", ts_prefs, {
      tsserver = { maxTsServerMemory = 8192 }, -- monorepos exhaust the 3GB default
    }),
    javascript = ts_prefs,
  },
})

-- workingDirectories=auto is the monorepo fix: without it eslint resolves the
-- config from cwd instead of the nearest package, and errors on every keystroke.
vim.lsp.config("eslint", {
  settings = {
    workingDirectories = { mode = "auto" },
  },
})

-- ---------------------------------------------------------------------------
-- C / C++
-- ---------------------------------------------------------------------------
vim.lsp.config("clangd", {
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--completion-style=detailed",
    "--header-insertion=never",
    "--offset-encoding=utf-16",
  },
  init_options = {
    fallbackFlags = { "-I/opt/homebrew/include" },
  },
  -- Markers, not a resolved path: root_dir must be decided per buffer. A
  -- vim.fs.root() call here would freeze the root to whatever buffer happened
  -- to be current when this file loaded.
  root_markers = { ".clangd", "compile_commands.json", "compile_flags.txt", ".git" },
})

-- ---------------------------------------------------------------------------
-- Python
-- ---------------------------------------------------------------------------
vim.lsp.config("pyright", {
  settings = {
    python = {
      analysis = {
        autoImportCompletions = true,
        typeCheckingMode = "basic",
        diagnosticMode = "openFilesOnly", -- workspace-wide is slow on big repos
        useLibraryCodeForTypes = true,
      },
    },
  },
})

-- ---------------------------------------------------------------------------
vim.lsp.enable {
  "html",
  "cssls",
  "jsonls",
  "clangd",
  "gopls",
  "pyright",
  "vtsls",
  "eslint",
  "tailwindcss",
}

-- Inlay hints are configured above but off by default; they're useful while
-- writing and noisy while reading.
vim.keymap.set("n", "<leader>ih", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = 0 }, { bufnr = 0 })
end, { desc = "LSP toggle inlay hints" })
