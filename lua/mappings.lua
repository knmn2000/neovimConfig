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
-- Alt+[ / Alt+] resize current window (both horizontal and vertical)
-- Note: Ctrl+[ is Escape in all terminals, so it can't be remapped
map("n", "<A-[>", "<cmd>resize -5<cr><cmd>vertical resize -5<cr>", { desc = "Decrease window size" })
map("n", "<A-]>", "<cmd>resize +5<cr><cmd>vertical resize +5<cr>", { desc = "Increase window size" })

-- Hide terminal buffer without closing it (keeps process alive)
map("n", "<leader>th", "<cmd>b#<cr>", { desc = "Hide terminal (switch to previous buffer)" })
map("t", "<A-h>", "<C-\\><C-n><cmd>b#<cr>", { desc = "Hide terminal from terminal mode" })

