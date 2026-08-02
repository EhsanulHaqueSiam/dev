-- UI.
return {
  -----------------------------------------------------------------------------
  -- Don't interrupt startup with the LazyVim/Neovim changelog popup
  -----------------------------------------------------------------------------
  {
    "LazyVim/LazyVim",
    opts = { news = { lazyvim = false, neovim = false } },
  },

  -----------------------------------------------------------------------------
  -- WHICH-KEY: only the groups LazyVim and the extras don't already declare
  -----------------------------------------------------------------------------
  {
    "folke/which-key.nvim",
    opts = {
      preset = "modern",
      delay = 300,
      spec = {
        { "<leader>gc", group = "conflict" },
        { "<leader>gv", group = "diffview" },
        { "<leader>gw", group = "worktree" },
        { "<leader>h", group = "harpoon" },
      },
    },
  },

  -----------------------------------------------------------------------------
  -- SNACKS: overrides only
  -----------------------------------------------------------------------------
  {
    "folke/snacks.nvim",
    opts = {
      zen = { toggles = { dim = true, git_signs = false, diagnostics = false } },
      scroll = { enabled = false }, -- smear-cursor already animates movement
      indent = { enabled = false }, -- indent-blankline + mini.indentscope own this
    },
    -- stylua: ignore
    keys = {
      { "<leader>z", function() Snacks.zen() end, desc = "Zen Mode" },
      { "<leader>Z", function() Snacks.zen.zoom() end, desc = "Zoom" },
    },
  },

  -----------------------------------------------------------------------------
  -- EDGY: sidebars are docked, not animated
  -----------------------------------------------------------------------------
  {
    "folke/edgy.nvim",
    opts = { animate = { enabled = false } },
  },

  -----------------------------------------------------------------------------
  -- DROPBAR: interactive winbar breadcrumbs — click or fuzzy-pick a symbol to
  -- jump. Replaces nvim-navic, which only ever printed a static path.
  -----------------------------------------------------------------------------
  {
    "Bekaboo/dropbar.nvim",
    event = "LspAttach",
    dependencies = { "folke/snacks.nvim" },
    opts = {
      bar = { hover = true },
      menu = {
        quick_navigation = true,
        preview = true,
      },
    },
    -- stylua: ignore
    keys = {
      { "<leader>cb", function() require("dropbar.api").pick() end, desc = "Pick Breadcrumb" },
    },
  },

  -----------------------------------------------------------------------------
  -- HELPVIEW: renders :help like the docs it's generated from
  -----------------------------------------------------------------------------
  {
    "OXY2DEV/helpview.nvim",
    lazy = false,
    ft = "help",
  },

  -----------------------------------------------------------------------------
  -- RAINBOW DELIMITERS
  -----------------------------------------------------------------------------
  {
    "HiPhish/rainbow-delimiters.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      local rainbow = require("rainbow-delimiters")
      vim.g.rainbow_delimiters = {
        strategy = { [""] = rainbow.strategy["global"], vim = rainbow.strategy["local"] },
        query = { [""] = "rainbow-delimiters", lua = "rainbow-blocks" },
        priority = { [""] = 110, lua = 210 },
        highlight = {
          "RainbowDelimiterRed",
          "RainbowDelimiterYellow",
          "RainbowDelimiterBlue",
          "RainbowDelimiterOrange",
          "RainbowDelimiterGreen",
          "RainbowDelimiterViolet",
          "RainbowDelimiterCyan",
        },
        -- Only attach to real file buffers that actually have a parser.
        -- Without this, floats from noice/blink/snacks trigger `parser is nil`.
        condition = function(bufnr)
          if not vim.api.nvim_buf_is_valid(bufnr) then
            return false
          end
          local bt = vim.bo[bufnr].buftype
          if bt ~= "" and bt ~= "acwrite" then
            return false
          end
          local ok, parser = pcall(vim.treesitter.get_parser, bufnr)
          return ok and parser ~= nil
        end,
      }
    end,
  },

  -----------------------------------------------------------------------------
  -- SCROLLBAR: diagnostics and search hits in the right margin
  -----------------------------------------------------------------------------
  {
    "petertriho/nvim-scrollbar",
    event = "VeryLazy",
    opts = {
      show_in_active_only = true,
      hide_if_all_visible = true,
      handle = { blend = 30, highlight = "CursorColumn" },
      marks = {
        Search = { highlight = "Search" },
        Error = { highlight = "DiagnosticVirtualTextError" },
        Warn = { highlight = "DiagnosticVirtualTextWarn" },
        Info = { highlight = "DiagnosticVirtualTextInfo" },
        Hint = { highlight = "DiagnosticVirtualTextHint" },
      },
      excluded_filetypes = {
        "noice",
        "prompt",
        "snacks_picker_list",
        "snacks_picker_input",
        "snacks_layout_box",
        "minifiles",
        "dashboard",
        "trouble",
      },
      handlers = { cursor = true, diagnostic = true, gitsigns = false, handle = true, search = false },
    },
  },

  -----------------------------------------------------------------------------
  -- RENDER-MARKDOWN: opts only; the LazyVim markdown extra installs it
  -----------------------------------------------------------------------------
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      heading = { sign = true, icons = { "# ", "## ", "### ", "#### ", "##### ", "###### " } },
      code = { sign = true, style = "full", left_pad = 1, right_pad = 1, language_pad = 1 },
      checkbox = { unchecked = { icon = " " }, checked = { icon = " " } },
      pipe_table = { style = "full" },
    },
  },

  -----------------------------------------------------------------------------
  -- BULLETS: continue and renumber markdown lists.
  -- Its <CR>/o/<leader>x maps are buffer-local to the filetypes below, so they
  -- don't shadow blink.cmp or mini.pairs anywhere else.
  -----------------------------------------------------------------------------
  {
    "dkarter/bullets.vim",
    ft = { "markdown", "text", "gitcommit" },
    init = function()
      vim.g.bullets_enabled_file_types = { "markdown", "text", "gitcommit" }
      vim.g.bullets_enable_in_empty_buffers = 0
      vim.g.bullets_set_mappings = 1
    end,
  },
}
