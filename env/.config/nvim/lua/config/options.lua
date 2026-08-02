require("config.remote_clipboard").setup()
-- Options
-- Only genuine overrides — LazyVim sets sensible defaults for everything else.

local opt = vim.opt

-----------------------------------------------------------------------------
-- OVERRIDES FROM LAZYVIM DEFAULTS
-----------------------------------------------------------------------------
opt.relativenumber = false -- LazyVim sets true; we prefer absolute only
opt.scrolloff = 8 -- LazyVim sets 4; we want more context
opt.pumblend = 10 -- Popup menu transparency
opt.winblend = 10 -- Floating window transparency
opt.concealcursor = "nc" -- Conceal in normal and command mode

-----------------------------------------------------------------------------
-- CUSTOM OPTIONS (not set by LazyVim)
-----------------------------------------------------------------------------
opt.listchars = { tab = ">> ", trail = ".", nbsp = "+" }
opt.shortmess:append({ W = true, I = true, c = true, C = true })

-- Global float border (Neovim 0.11+). Plugins that don't hardcode a border
-- inherit this, so per-plugin `border = "rounded"` settings are unnecessary.
vim.o.winborder = "rounded"

-----------------------------------------------------------------------------
-- SPELL
-----------------------------------------------------------------------------
opt.spelloptions:append("noplainbuffer")

-----------------------------------------------------------------------------
-- PERFORMANCE
-----------------------------------------------------------------------------
opt.synmaxcol = 240
opt.redrawtime = 1500

-----------------------------------------------------------------------------
-- PROVIDERS (none of these are used; skip the startup probes)
-----------------------------------------------------------------------------
vim.g.python3_host_prog = vim.fn.exepath("python3")
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0

-----------------------------------------------------------------------------
-- FILETYPE SPECIFIC
-----------------------------------------------------------------------------
vim.g.markdown_recommended_style = 0
vim.g.autoformat = true

-- LazyVim's php extra defaults to phpactor; intelephense is what's installed.
vim.g.lazyvim_php_lsp = "intelephense"

-----------------------------------------------------------------------------
-- ROOT DETECTION (monorepo-aware)
-----------------------------------------------------------------------------
vim.g.root_spec = {
  "lsp",
  {
    ".git",
    "lua",
    "package.json",
    "tsconfig.json",
    "vite.config.ts",
    "vitest.config.ts",
    "bun.lockb",
    "bunfig.toml",
    "Cargo.toml",
    "go.mod",
    "pyproject.toml",
    "Makefile",
    "pnpm-workspace.yaml",
  },
  "cwd",
}
