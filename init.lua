vim.g.base46_cache = vim.fn.stdpath "data" .. "/nvchad/base46/"
vim.g.mapleader = " "

vim.cmd "autocmd VimEnter * PlugInstall --sync | source $MYVIMRC"
vim.cmd "autocmd VimEnter * q"
-- In your init.lua or Neovim configuration
vim.g.neoformat_try_formatprg = 1 -- Enable running external formatter programs

-- SQL formatting with sql-formatter
vim.cmd [[
  au BufRead,BufNewFile *.sql,*.mysql,*.pgsql,*.sqlite,*.mysql.twig,*.pgsql.twig,*.sqlite.twig setlocal formatprg=sql-formatter\ -s\2\ -g
]]

function _G.copy_current_file_path()
  local filepath = vim.api.nvim_buf_get_name(0)
  vim.fn.setreg("+", filepath) -- Copy to system clipboard
  print("Copied file path: " .. filepath)
end

-- map <leader>cp to copy current file path
vim.api.nvim_set_keymap("n", "<leader>cp", ":lua copy_current_file_path()<CR>", { noremap = true, silent = true })

-- PLUGS
vim.cmd [[
call plug#begin('~/.local/share/nvim/plugged')

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'maxmellon/vim-jsx-pretty'  
Plug 'JoosepAlviste/nvim-ts-context-commentstring'
Plug 'glepnir/lspsaga.nvim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'windwp/nvim-ts-autotag'
Plug 'windwp/nvim-autopairs'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'neovim/nvim-lspconfig'
Plug 'jose-elias-alvarez/null-ls.nvim'
Plug 'tpope/vim-fugitive'
Plug 'github/copilot.vim'
Plug 'tpope/vim-commentary'
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
Plug 'neovim/nvim-lspconfig'          " LSP configurations
Plug 'hrsh7th/nvim-cmp'               " Completion plugin
Plug 'hrsh7th/cmp-nvim-lsp'           " LSP source for nvim-cmp
Plug 'hrsh7th/cmp-buffer'             " Buffer source for nvim-cmp
Plug 'hrsh7th/cmp-path'               " Path source for nvim-cmp
Plug 'hrsh7th/cmp-cmdline'            " Cmdline source for nvim-cmp
Plug 'L3MON4D3/LuaSnip'               " Snippet engine
Plug 'saadparwaiz1/cmp_luasnip'       " Snippet source for nvim-cmp

call plug#end()
]]

local nvim_lsp = require "lspconfig"
nvim_lsp.tsserver.setup {}

-- LAZY VIM
-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"
vim.lsp.buf.format {
  filter = function(client)
    return client.name ~= "tsserver"
  end,
}

-- load plugins
--
require("nvim-ts-autotag").setup {
  opts = {
    -- Defaults
    enable_close = true, -- Auto close tags
    enable_rename = true, -- Auto rename pairs of tags
    enable_close_on_slash = false, -- Auto close on trailing </
  },
  -- Also override individual filetype configs, these take priority.
  -- Empty by default, useful if one of the "opts" global settings
  -- doesn't work well in a specific filetype
  per_filetype = {
    ["html"] = {
      enable_close = false,
    },
  },
}

require("lazy").setup({
  {
    "nvimdev/lspsaga.nvim",
    config = function()
      require("lspsaga").setup {}
    end,
    dependencies = {
      "nvim-treesitter/nvim-treesitter", -- optional
      "nvim-tree/nvim-web-devicons", -- optional
    },
  },
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
    config = function()
      require "options"
    end,
  },
  { "junegunn/fzf", dir = "~/.fzf", build = "./install --all" },
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons", "junegunn/fzf" },
    config = function()
      -- calling `setup` is optional for customization
      require("fzf-lua").setup {
        -- Configure files preview options
        files = {
          -- Disable the previewer to focus on file names
          previewer = false,

          -- Customize the display format using `--with-nth` and `--delimiter`
          fzf_opts = {
            ["--with-nth"] = "3..", -- Display everything from the second field onwards
            ["--tiebreak"] = "length", -- Sort by length for tiebreakers
          },
        },
      }
    end,
  },
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup {}
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local null_ls = require "null-ls"

      null_ls.setup {
        sources = {
          null_ls.builtins.formatting.prettier.with {
            extra_filetypes = {
              "javascript",
              "typescript",
              "json",
              "css",
              "html",
              "markdown",
              "typescriptreact",
              "javascriptreact",
            },
          },
        },
        on_attach = function(client, bufnr)
          if client.server_capabilities.documentFormattingProvider then
            vim.api.nvim_create_augroup("LspFormatting", { clear = true })
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = "LspFormatting",
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format()
              end,
            })
          end
        end,
      }
    end,
  },
  {
    "ruifm/gitlinker.nvim",
    requires = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("gitlinker").setup()
    end,
  },

  { import = "plugins" },
}, lazy_config)

require("conform").setup {
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "isort", "black" },
    javascript = { { "prettierd", "prettier" } },
    typescript = { { "prettierd", "prettier" } },
    typescriptreact = { { "prettier", "prettierd" } },
    javascriptreact = { { "prettier", "prettierd" } },
    json = { { "prettierd", "prettier" } },
    html = { { "prettierd", "prettier" } },
    css = { { "prettierd", "prettier" } },
    sql = { { "sqlfmt" } },
  },
}

-- format on save
vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function()
    require("conform").format()
  end,
})

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "nvchad.autocmds"

-- LANGUAGE SERVERS
-- LSP and Null-LS setup
local lspconfig = require "lspconfig"
local null_ls = require "null-ls"

-- Setup null-ls with formatters
null_ls.setup {
  sources = {
    null_ls.builtins.formatting.prettier, -- For JavaScript, TypeScript, etc.
    null_ls.builtins.formatting.stylua, -- For Lua
    null_ls.builtins.formatting.black, -- For Python
    null_ls.builtins.formatting.sql_formatter, -- For SQL
    -- Add other formatters as needed
  },
  on_attach = function(client, bufnr)
    if client.resolved_capabilities.document_formatting then
      vim.cmd [[
        augroup LspFormatting
          autocmd! * <buffer>
          autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()
        augroup END
      ]]
    end
  end,
}

-- Setup LSP servers
lspconfig.tsserver.setup {
  on_attach = function(client, bufnr)
    client.resolved_capabilities.document_formatting = false -- Use null-ls for formatting
  end,
}

lspconfig.pyright.setup {}
-- lspconfig.sumneko_lua.setup({
--   cmd = { "lua-language-server" },
--   settings = {
--     Lua = {
--       diagnostics = {
--         globals = { 'vim' },
--       },
--     },
--   },
-- })

-- Additional LSP servers can be configured here

vim.cmd [[
    autocmd! User LspAttach lua require('lspsaga').setup({})
]]

vim.api.nvim_exec(
  [[
  augroup TSContextCommentstring
    autocmd!
    autocmd FileType typescriptreact lua require('ts_context_commentstring.internal').update_commentstring()
  augroup END
]],
  false
)
-- Ensure proper filetype detection for .tsx files
vim.api.nvim_exec(
  [[
  autocmd BufRead,BufNewFile *.tsx set filetype=typescriptreact
]],
  false
)

-- Set comment string for typescriptreact filetype
-- Fix the issue with uncommenting
vim.api.nvim_exec(
  [[
  function! ToggleCommentType()
    let l:commentstring = &commentstring
    if l:commentstring == '{/* %s */}'
      setlocal commentstring=//\ %s
    else
      setlocal commentstring={/*\ %s\ */}
    endif
  endfunction

  augroup TSCommentToggle
    autocmd!
    autocmd FileType typescriptreact autocmd BufEnter <buffer> call ToggleCommentType()
  augroup END
]],
  false
)

vim.schedule(function()
  require "mappings"
end)
