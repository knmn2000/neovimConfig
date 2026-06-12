require "nvchad.options"

-- Window title shows folder name (for Kitty tab bar)
vim.opt.title = true

-- Update title to show current working directory
local function update_title()
  local cwd = vim.fn.getcwd()
  local folder = vim.fn.fnamemodify(cwd, ":t") -- just the folder name
  vim.opt.titlestring = folder
end

update_title()

-- Update title when changing directory
vim.api.nvim_create_autocmd("DirChanged", {
  callback = update_title,
})
