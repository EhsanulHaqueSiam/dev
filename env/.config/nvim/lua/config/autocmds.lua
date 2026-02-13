-- Custom autocmds (LazyVim provides many defaults)
-- Only custom ones that LazyVim doesn't provide

local function augroup(name)
  return vim.api.nvim_create_augroup("custom_" .. name, { clear = true })
end

-----------------------------------------------------------------------------
-- AUTO-SAVE: Save files automatically
-----------------------------------------------------------------------------
vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
  group = augroup("auto_save"),
  pattern = "*",
  callback = function(event)
    local bufnr = event.buf
    if not vim.bo[bufnr].modifiable then return end
    if vim.bo[bufnr].buftype ~= "" then return end
    if vim.bo[bufnr].readonly then return end
    local filename = vim.api.nvim_buf_get_name(bufnr)
    if filename == "" then return end
    if vim.fn.mode() == "c" or vim.fn.mode() == "o" then return end
    vim.defer_fn(function()
      if vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].modified then
        vim.api.nvim_buf_call(bufnr, function()
          vim.cmd("silent! update")
        end)
      end
    end, 500)
  end,
  desc = "Auto-save on insert leave or text change",
})

-----------------------------------------------------------------------------
-- AUTO-CREATE DIRECTORIES: Create parent dirs when saving
-----------------------------------------------------------------------------
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup("auto_create_dir"),
  callback = function(event)
    if event.match:match("^%w%w+:[\\/][\\/]") then return end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
  desc = "Auto-create parent directories when saving",
})

-----------------------------------------------------------------------------
-- AUTO-CURSORLINE: Only show cursorline in active window
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
-- AUTO-FORMAT-OPTIONS: Fix formatoptions on FileType
-----------------------------------------------------------------------------
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("fix_formatoptions"),
  callback = function()
    vim.opt_local.formatoptions:remove({ "r", "o" })
  end,
  desc = "Don't auto-insert comment leader on Enter or o/O",
})

-----------------------------------------------------------------------------
-- AUTO-LARGE-FILE: Disable features for large files
-----------------------------------------------------------------------------
vim.api.nvim_create_autocmd("BufReadPre", {
  group = augroup("large_file"),
  callback = function(event)
    local file = event.match
    local size = vim.fn.getfsize(file)
    if size > 1024 * 1024 then -- 1MB
      vim.b[event.buf].large_file = true
      vim.opt_local.swapfile = false
      vim.opt_local.undofile = false
      vim.opt_local.syntax = "off"
      vim.opt_local.foldmethod = "manual"
      vim.cmd("syntax clear")
    end
  end,
  desc = "Disable features for large files",
})

-----------------------------------------------------------------------------
-- AUTO-TERMINAL: Terminal specific settings
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
-- AUTO-QUICKFIX: Auto-open quickfix/loclist when populated
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

-----------------------------------------------------------------------------
-- AUTO-LSP-CODELENS: Auto-refresh code lens
-----------------------------------------------------------------------------
vim.api.nvim_create_autocmd("LspAttach", {
  group = augroup("lsp_codelens"),
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client.supports_method("textDocument/codeLens") then
      vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
        group = vim.api.nvim_create_augroup("lsp_codelens_" .. event.buf, { clear = true }),
        buffer = event.buf,
        callback = function()
          vim.lsp.codelens.refresh({ bufnr = event.buf })
        end,
      })
    end
  end,
  desc = "Auto-refresh code lens",
})
