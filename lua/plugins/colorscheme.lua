return {
  -- Add the VS Code theme plugin
  {
    "Mofiqul/vscode.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      -- Optional: customize the style (dark, light, or modern)
      style = 'dark',
    },
  },

  -- Configure LazyVim to use it as the default
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "vscode",
    },
  },
}
