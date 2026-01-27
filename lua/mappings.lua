require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- Normal Mode
map("n", "<C-_>", "gcc", { desc = "toggle comment", remap = true })

-- Visual Mode
map("v", "<C-_>", "gc", { desc = "toggle comment", remap = true })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
map("n", "<A-[>", "<cmd>vertical resize -5<cr>")
map("n", "<A-]>", "<cmd>vertical resize +5<cr>")

