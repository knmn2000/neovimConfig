require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
--
-- -- Define mappings for fzf-lua
map("n", "<leader>ff", "<cmd>lua require('fzf-lua').files()<CR>", opts)
map("n", "<leader>fg", "<cmd>lua require('fzf-lua').live_grep()<CR>", opts)
map("n", "<leader>fb", "<cmd>lua require('fzf-lua').buffers()<CR>", opts)
map("n", "<leader>fh", "<cmd>lua require('fzf-lua').help_tags()<CR>", opts)
map("n", "<leader>fo", "<cmd>lua require('fzf-lua').oldfiles()<CR>", opts)
map("n", "<leader>fb", "<cmd>lua require('fzf-lua').buffers()<CR>", opts)
map("n", "<leader>ft", "<cmd>lua require('fzf-lua').tabs()<CR>", opts)
map("n", "<leader>ft", "<cmd>lua require('fzf-lua').tabs()<CR>", opts)

map("n", "<leader>D", ":Gvdiffsplit", opts)

map("n", "<leader>=", ":vertical resize +15<CR>", opts)
map("n", "<leader>-", ":vertical resize -15<CR>", opts)
map("n", "<leader>fp", "npx prettier 'src/**/*.{js,ts,mjs,cjs,json,jsx,tsx,scss,css}' --write", opts)

-- non leader mappings
map("n", "gd", "<cmd>Telescope lsp_definitions<CR>")
vim.api.nvim_set_keymap("n", "K", ":Lspsaga hover_doc<CR>", { silent = true, noremap = true })
