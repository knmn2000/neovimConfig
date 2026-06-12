require "nvchad.autocmds"

-- Attach treesitter in diff mode buffers (diff highlight colors are handled in
-- the diffview plugin spec via its own DiffviewDiff* groups + User event).
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function(args)
    if vim.wo.diff then
      pcall(vim.treesitter.start, args.buf)
    end
  end,
})
