-- Custom keymaps (LazyVim provides most defaults)
-- Only truly custom keymaps that LazyVim doesn't provide

local map = vim.keymap.set

-----------------------------------------------------------------------------
-- GENERAL (custom only)
-----------------------------------------------------------------------------
-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })

-- Better paste (don't yank when pasting over selection)
map("x", "p", [["_dP]], { desc = "Paste without yanking" })

-- Quick quit (force)
map("n", "<leader>qQ", "<cmd>qa!<cr>", { desc = "Quit all (force)" })

-- Join lines without moving cursor
map("n", "J", "mzJ`z", { desc = "Join lines" })

-- Center screen on page up/down
map("n", "<C-d>", "<C-d>zz", { desc = "Page down (centered)" })
map("n", "<C-u>", "<C-u>zz", { desc = "Page up (centered)" })

-----------------------------------------------------------------------------
-- TERMINAL (custom only - LazyVim provides C-h/j/k/l)
-----------------------------------------------------------------------------
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
map("t", "<C-/>", "<cmd>close<cr>", { desc = "Hide terminal" })

-----------------------------------------------------------------------------
-- LSP (custom only - LazyVim provides gd, gr, ca, etc.)
-----------------------------------------------------------------------------
map("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
map("n", "gK", vim.lsp.buf.signature_help, { desc = "Signature help" })
map("i", "<C-k>", vim.lsp.buf.signature_help, { desc = "Signature help" })
map("n", "<leader>cl", vim.lsp.codelens.run, { desc = "Run CodeLens" })
map("n", "<leader>cL", vim.lsp.codelens.refresh, { desc = "Refresh CodeLens" })

-----------------------------------------------------------------------------
-- TOGGLE OPTIONS (only ones LazyVim doesn't provide)
-- LazyVim provides: <leader>uw (wrap), <leader>ul (line numbers),
--   <leader>uL (relative numbers), <leader>us (spell), <leader>ud (diagnostics),
--   <leader>uh (inlay hints) — all with Snacks.toggle (shows notification)
-----------------------------------------------------------------------------
map("n", "<leader>uC", "<cmd>set cursorline!<cr>", { desc = "Toggle cursor line" })

-----------------------------------------------------------------------------
-- MISC (custom only)
-----------------------------------------------------------------------------
-- Add blank lines
map("n", "]<space>", "o<Esc>k", { desc = "Add blank line below" })
map("n", "[<space>", "O<Esc>j", { desc = "Add blank line above" })

-- Better command mode navigation
map("c", "<C-a>", "<Home>", { desc = "Start of line" })
map("c", "<C-e>", "<End>", { desc = "End of line" })
map("c", "<C-h>", "<Left>", { desc = "Left" })
map("c", "<C-l>", "<Right>", { desc = "Right" })

-- Undo breakpoints
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", ";", ";<c-g>u")
