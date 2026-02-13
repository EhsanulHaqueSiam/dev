-- Options configuration
-- Only genuine overrides (LazyVim sets sensible defaults for most options)

local opt = vim.opt

-----------------------------------------------------------------------------
-- OVERRIDES FROM LAZYVIM DEFAULTS
-----------------------------------------------------------------------------
opt.relativenumber = false    -- LazyVim sets true; we prefer absolute only
opt.scrolloff = 8             -- LazyVim sets 4; we want more context
opt.sidescrolloff = 8         -- LazyVim sets 8; same
opt.pumblend = 10             -- Popup menu transparency
opt.winblend = 10             -- Floating window transparency
opt.cmdheight = 1             -- Command line height
opt.conceallevel = 2          -- Hide * markup for bold and italic
opt.concealcursor = "nc"      -- Conceal in normal and command mode

-----------------------------------------------------------------------------
-- CUSTOM OPTIONS (not set by LazyVim)
-----------------------------------------------------------------------------
opt.listchars = { tab = ">> ", trail = ".", nbsp = "+" }
opt.fillchars = {
  foldopen = "-",
  foldclose = "+",
  fold = " ",
  foldsep = " ",
  diff = "/",
  eob = " ",
}
opt.shortmess:append({ W = true, I = true, c = true, C = true })
opt.virtualedit = "block"
opt.smoothscroll = true
opt.statuscolumn = [[%!v:lua.require'snacks.statuscolumn'.get()]]

-----------------------------------------------------------------------------
-- COMPLETION
-----------------------------------------------------------------------------
opt.completeopt = "menu,menuone,noselect"
opt.wildmode = "longest:full,full"
opt.complete:append("kspell")

-----------------------------------------------------------------------------
-- FOLDING (Treesitter-based, ufo handles runtime)
-----------------------------------------------------------------------------
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldtext = ""
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = true

-----------------------------------------------------------------------------
-- SPELL
-----------------------------------------------------------------------------
opt.spelllang = { "en" }
opt.spelloptions:append("noplainbuffer")

-----------------------------------------------------------------------------
-- PERFORMANCE
-----------------------------------------------------------------------------
opt.synmaxcol = 240
opt.redrawtime = 1500

-----------------------------------------------------------------------------
-- PROVIDERS
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

-----------------------------------------------------------------------------
-- COLORSCHEME (explicit — change this to switch themes)
-----------------------------------------------------------------------------
vim.g.lazyvim_colorscheme = "tokyonight"

-----------------------------------------------------------------------------
-- ROOT DETECTION (monorepo-aware)
-----------------------------------------------------------------------------
vim.g.root_spec = {
  "lsp",
  { ".git", "lua", "package.json", "tsconfig.json", "vite.config.ts", "vitest.config.ts", "bun.lockb", "bunfig.toml", "Cargo.toml", "go.mod", "pyproject.toml", "Makefile", "pnpm-workspace.yaml" },
  "cwd",
}
