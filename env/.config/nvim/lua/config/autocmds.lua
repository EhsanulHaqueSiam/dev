-- Custom autocmds. LazyVim already provides: checktime, highlight-on-yank,
-- resize-splits, last-loc, close-with-q, man-unlisted, wrap+spell, json
-- conceal and auto-create-dir. snacks.bigfile handles large files. Only add
-- what's genuinely missing.

local function augroup(name)
  return vim.api.nvim_create_augroup("custom_" .. name, { clear = true })
end

-----------------------------------------------------------------------------
-- AUTO-SAVE
-- Deliberately NOT on TextChanged: every normal-mode edit (including `u`)
-- would then trip BufWritePre, and format-on-save would reformat and move the
-- cursor while you work. Leaving insert / the buffer / the window is enough.
-----------------------------------------------------------------------------
vim.api.nvim_create_autocmd({ "InsertLeave", "BufLeave", "FocusLost" }, {
  group = augroup("auto_save"),
  callback = function(event)
    local buf = event.buf
    if not (vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].modified) then
      return
    end
    if vim.bo[buf].buftype ~= "" or not vim.bo[buf].modifiable or vim.bo[buf].readonly then
      return
    end
    if vim.api.nvim_buf_get_name(buf) == "" then
      return
    end
    vim.api.nvim_buf_call(buf, function()
      vim.cmd("silent! lockmarks update")
    end)
  end,
  desc = "Auto-save on leaving insert/buffer/window",
})

-----------------------------------------------------------------------------
-- CURSORLINE: only in the active window
-----------------------------------------------------------------------------
vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter", "InsertLeave" }, {
  group = augroup("cursorline_active"),
  callback = function()
    if vim.w.auto_cursorline then
      vim.wo.cursorline = true
      vim.w.auto_cursorline = nil
    end
  end,
  desc = "Show cursorline in active window",
})

vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave", "InsertEnter" }, {
  group = augroup("cursorline_inactive"),
  callback = function()
    if vim.wo.cursorline then
      vim.w.auto_cursorline = true
      vim.wo.cursorline = false
    end
  end,
  desc = "Hide cursorline in inactive window",
})

-----------------------------------------------------------------------------
-- Don't auto-insert the comment leader on Enter or o/O
-----------------------------------------------------------------------------
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("fix_formatoptions"),
  callback = function()
    vim.opt_local.formatoptions:remove({ "r", "o" })
  end,
  desc = "No comment continuation on <CR> / o / O",
})

-----------------------------------------------------------------------------
-- TERMINAL
-----------------------------------------------------------------------------
vim.api.nvim_create_autocmd("TermOpen", {
  group = augroup("term_settings"),
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
    vim.opt_local.spell = false
    vim.cmd("startinsert")
  end,
  desc = "Terminal settings",
})

-----------------------------------------------------------------------------
-- QUICKFIX / LOCLIST: open when populated
-----------------------------------------------------------------------------
vim.api.nvim_create_autocmd("QuickFixCmdPost", {
  group = augroup("quickfix_auto_open"),
  pattern = { "[^l]*" },
  callback = function()
    vim.cmd("cwindow")
  end,
  desc = "Auto-open quickfix",
})

vim.api.nvim_create_autocmd("QuickFixCmdPost", {
  group = augroup("loclist_auto_open"),
  pattern = { "l*" },
  callback = function()
    vim.cmd("lwindow")
  end,
  desc = "Auto-open location list",
})
