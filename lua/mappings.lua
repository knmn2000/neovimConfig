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
-- Alt+[ / Alt+] vertical resize only
map("n", "<A-[>", "<cmd>vertical resize -5<cr>")
map("n", "<A-]>", "<cmd>vertical resize +5<cr>")
map("n", "<leader>n", "<nop>")

-- Ctrl+[ / Ctrl+] resize current window (both horizontal and vertical)
map("n", "<C-[>", "<cmd>resize -5<cr><cmd>vertical resize -5<cr>", { desc = "Decrease window size" })
map("n", "<C-]>", "<cmd>resize +5<cr><cmd>vertical resize +5<cr>", { desc = "Increase window size" })
map("n", "<leader>cp", function()
  local path = vim.fn.expand("%:.")
  vim.fn.setreg("+", path)
  vim.notify('Copied relative path: ' or path)
end, { desc = "Copy relative path to clipboard" })

-- Find files filtered by extension, e.g. type "tsx" to search only *.tsx
map("n", "<leader>fx", function()
  local ext = vim.fn.input("Extension (no dot): ")
  if ext == "" then return end
  require("telescope.builtin").find_files({
    find_command = { "fd", "--type", "f", "--hidden", "--strip-cwd-prefix", "-e", ext },
  })
end, { desc = "Find files by extension" })

local mc = require("multicursor-nvim")

-- Add or skip adding a new cursor by matching word/selection
map({ "n", "x" }, "<leader>n", function() mc.matchAddCursor(1) end, { desc = "Add cursor to next match" })
map({ "n", "x" }, "<leader>s", function() mc.matchSkipCursor(1) end, { desc = "Skip next match" })
map({ "n", "x" }, "<leader>N", function() mc.matchAddCursor(-1) end, { desc = "Add cursor to prev match" })

-- Up and Down arrows for column mode
map({ "n", "x" }, "<up>", function() mc.lineAddCursor(-1) end)
map({ "n", "x" }, "<down>", function() mc.lineAddCursor(1) end)

-- Git keybinds (gitsigns + neogit + diffview).
-- gitsigns is loaded eagerly in init.lua; require lazily inside callbacks so a
-- failure here can never take down the mappings defined above.
local function gs() return require("gitsigns") end

map("n", "]h", function() gs().next_hunk() end,                                    { desc = "Git: next hunk" })
map("n", "[h", function() gs().prev_hunk() end,                                    { desc = "Git: prev hunk" })
map("n", "<leader>gg", function() require("neogit").open({ kind = "vsplit" }) end, { desc = "Git: Neogit" })
map("n", "<leader>gp", function() gs().preview_hunk() end,                         { desc = "Git: preview hunk" })
map("n", "<leader>gs", function() gs().stage_hunk() end,                           { desc = "Git: stage hunk" })
map("n", "<leader>gr", function() gs().reset_hunk() end,                           { desc = "Git: reset hunk" })
map("v", "<leader>gs", function() gs().stage_hunk { vim.fn.line("."), vim.fn.line("v") } end, { desc = "Git: stage selected" })
map("v", "<leader>gr", function() gs().reset_hunk { vim.fn.line("."), vim.fn.line("v") } end, { desc = "Git: reset selected" })
map("n", "<leader>gS", function() gs().stage_buffer() end,                         { desc = "Git: stage file" })
map("n", "<leader>gR", function() gs().reset_buffer() end,                         { desc = "Git: reset file" })
map("n", "<leader>gb", function() gs().toggle_current_line_blame() end,            { desc = "Git: toggle blame" })
map("n", "<leader>gd", "<cmd>DiffviewOpen<CR>",                                    { desc = "Git: diff all changes" })
map("n", "<leader>gD", "<cmd>DiffviewFileHistory %<CR>",                           { desc = "Git: diff current file" })
map("n", "<leader>gh", "<cmd>DiffviewFileHistory %<CR>",                           { desc = "Git: file history" })
map("n", "<leader>gH", "<cmd>DiffviewFileHistory<CR>",                             { desc = "Git: repo history" })
map("n", "<leader>gx", "<cmd>DiffviewClose<CR>",                                   { desc = "Git: close diffview" })

-- Send visual selection to Claude terminal (clipboard + open float term)
map("v", "<leader>da", function()
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  local lines = vim.fn.getline(start_pos[2], end_pos[2])

  if type(lines) == "string" then
    lines = { lines }
  end

  vim.fn.setreg("+", table.concat(lines, "\n"))
  require("nvchad.term").toggle { pos = "float", id = "floatTerm" }
  vim.notify("Selection copied! Paste in Claude with Cmd+V")
end, { desc = "Copy selection + open Claude terminal" })
