-- Custom keymaps only.
-- LazyVim already binds gd/gD/gr/gI/gy/K/gK/<C-k>, <leader>ca/cc/cC/cl/cr/cR/cA/co,
-- window + buffer motions, and the terminal <C-h/j/k/l> splits.

local map = vim.keymap.set

-----------------------------------------------------------------------------
-- GENERAL
-----------------------------------------------------------------------------
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })

-- Paste over a selection without clobbering the unnamed register
map("x", "p", [["_dP]], { desc = "Paste without yanking" })

map("n", "<leader>qQ", "<cmd>qa!<cr>", { desc = "Quit all (force)" })

-- Join lines without moving the cursor
map("n", "J", "mzJ`z", { desc = "Join lines" })

-- Keep the cursor centred on half-page jumps
map("n", "<C-d>", "<C-d>zz", { desc = "Page down (centered)" })
map("n", "<C-u>", "<C-u>zz", { desc = "Page up (centered)" })

-----------------------------------------------------------------------------
-- TERMINAL
-----------------------------------------------------------------------------
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
map("t", "<C-/>", "<cmd>close<cr>", { desc = "Hide terminal" })

-----------------------------------------------------------------------------
-- TOGGLES (LazyVim covers wrap/numbers/spell/diagnostics/inlay hints)
-----------------------------------------------------------------------------
map("n", "<leader>uC", "<cmd>set cursorline!<cr>", { desc = "Toggle cursor line" })

-----------------------------------------------------------------------------
-- MISC
-----------------------------------------------------------------------------
map("n", "]<space>", "o<Esc>k", { desc = "Add blank line below" })
map("n", "[<space>", "O<Esc>j", { desc = "Add blank line above" })

-- Readline-ish command-line navigation
map("c", "<C-a>", "<Home>", { desc = "Start of line" })
map("c", "<C-e>", "<End>", { desc = "End of line" })
map("c", "<C-h>", "<Left>", { desc = "Left" })
map("c", "<C-l>", "<Right>", { desc = "Right" })

-- Undo breakpoints, so a long insert isn't one giant undo step
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", ";", ";<c-g>u")
