-- Sticky scroll: keeps the enclosing function / class / block pinned to the top
-- of the window, the way VS Code's sticky scroll does.
return {
  {
    "nvim-treesitter/nvim-treesitter-context",
    -- Uses Neovim's built-in vim.treesitter, but needs nvim-treesitter on the
    -- runtimepath for the parsers.
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = "User FilePost", -- NvChad's own lazy-load trigger, same as lspconfig
    opts = {
      -- "topline" matches VS Code: show the scopes that have scrolled off the
      -- top. ("cursor" instead shows the scopes around the cursor, even when
      -- their opening line is still visible.)
      mode = "topline",
      max_lines = 4, -- deep JSX/nested closures can otherwise eat the window
      trim_scope = "outer", -- over max_lines, drop the outermost scope first
      multiline_threshold = 1, -- collapse a wrapped signature to its first line
      min_window_height = 20, -- don't steal rows in a short split
      separator = "─",
      line_numbers = true,
    },
    config = function(_, opts)
      require("treesitter-context").setup(opts)

      -- base46 doesn't theme these groups, so they'd fall back to NormalFloat
      -- (#19192c) -- all but invisible against the editor bg (#141423). Same
      -- set-then-reapply-on-ColorScheme pattern the diffview spec uses, because
      -- base46 loads after startup and would otherwise clobber these.
      local function set_context_hl()
        vim.api.nvim_set_hl(0, "TreesitterContext", { bg = "#23233d" })
        vim.api.nvim_set_hl(0, "TreesitterContextLineNumber", { bg = "#23233d", fg = "#6060a4" })
        vim.api.nvim_set_hl(0, "TreesitterContextSeparator", { fg = "#414171" })
      end

      set_context_hl()
      vim.api.nvim_create_autocmd("ColorScheme", { callback = set_context_hl })

      -- [C jumps to the context line above (takes a count). NOT [c: that's
      -- Vim's built-in previous-diff-change motion, needed in diffview.
      vim.keymap.set("n", "[C", function()
        require("treesitter-context").go_to_context(vim.v.count1)
      end, { silent = true, desc = "Jump to context (parent scope)" })

      vim.keymap.set("n", "<leader>tc", "<cmd>TSContext toggle<cr>", { desc = "Toggle sticky context" })
    end,
  },
}
