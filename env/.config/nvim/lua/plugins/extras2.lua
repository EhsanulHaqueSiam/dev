-- More Quality of Life plugins
return {
  -----------------------------------------------------------------------------
  -- UNDOTREE: Visual undo history
  -----------------------------------------------------------------------------
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    keys = {
      { "<leader>uu", "<cmd>UndotreeToggle<cr>", desc = "Undo Tree" },
    },
    config = function()
      vim.g.undotree_WindowLayout = 2
      vim.g.undotree_ShortIndicators = 1
      vim.g.undotree_SplitWidth = 30
      vim.g.undotree_DiffpanelHeight = 10
      vim.g.undotree_SetFocusWhenToggle = 1
      vim.g.undotree_TreeNodeShape = "o"
      vim.g.undotree_TreeVertShape = "|"
      vim.g.undotree_TreeSplitShape = "/"
      vim.g.undotree_TreeReturnShape = "\\"
      vim.g.undotree_DiffAutoOpen = 1
      vim.g.undotree_HighlightChangedText = 1
      vim.g.undotree_HighlightChangedWithSign = 1
      vim.g.undotree_HelpLine = 0
    end,
  },

  -----------------------------------------------------------------------------
  -- TREESJ: Split/join code blocks
  -----------------------------------------------------------------------------
  {
    "Wansmer/treesj",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      use_default_keymaps = false,
      max_join_length = 150,
    },
    keys = {
      { "<leader>cj", function() require("treesj").toggle() end, desc = "Split/Join Toggle" },
      { "<leader>cJ", function() require("treesj").toggle({ split = { recursive = true } }) end, desc = "Split/Join Recursive" },
    },
  },

  -----------------------------------------------------------------------------
  -- UFO: Better code folding
  -----------------------------------------------------------------------------
  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    event = "VeryLazy",
    opts = {
      provider_selector = function(_, filetype, _)
        local ftMap = {
          vim = "indent",
          python = { "treesitter", "indent" },
          git = "",
        }
        return ftMap[filetype] or { "lsp", "indent" }
      end,
      open_fold_hl_timeout = 150,
      fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local suffix = (" ... %d "):format(endLnum - lnum)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
            end
            break
          end
          curWidth = curWidth + chunkWidth
        end
        table.insert(newVirtText, { suffix, "MoreMsg" })
        return newVirtText
      end,
    },
    init = function()
      vim.o.foldcolumn = "1"
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
    end,
    keys = {
      { "zR", function() require("ufo").openAllFolds() end, desc = "Open All Folds" },
      { "zM", function() require("ufo").closeAllFolds() end, desc = "Close All Folds" },
      { "zr", function() require("ufo").openFoldsExceptKinds() end, desc = "Open Folds Except" },
      { "zm", function() require("ufo").closeFoldsWith() end, desc = "Close Folds With" },
      { "zp", function() require("ufo").peekFoldedLinesUnderCursor() end, desc = "Peek Fold" },
    },
  },

  -----------------------------------------------------------------------------
  -- SCROLLBAR: Visual scrollbar with diagnostics
  -----------------------------------------------------------------------------
  {
    "petertriho/nvim-scrollbar",
    event = "VeryLazy",
    opts = {
      show = true,
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
      excluded_filetypes = { "noice", "prompt", "snacks_picker", "snacks_explorer", "minifiles", "dashboard" },
      handlers = { cursor = true, diagnostic = true, gitsigns = false, handle = true, search = false },
    },
  },

  -----------------------------------------------------------------------------
  -- MARKS: Visual marks in gutter
  -----------------------------------------------------------------------------
  {
    "chentoast/marks.nvim",
    event = "VeryLazy",
    opts = {
      default_mappings = true,
      builtin_marks = { ".", "<", ">", "^" },
      cyclic = true,
      sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20 },
      bookmark_0 = { sign = "!" },
      mappings = { set_next = "m,", next = "m]", prev = "m[", preview = "m:", delete_line = "dm-", delete_buf = "dm<space>" },
    },
  },

  -----------------------------------------------------------------------------
  -- VIM-MATCHUP: Better % matching
  -----------------------------------------------------------------------------
  {
    "andymass/vim-matchup",
    event = "VeryLazy",
    init = function()
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
      vim.g.matchup_matchparen_deferred = 1
      vim.g.matchup_matchparen_hi_surround_always = 1
    end,
  },

  -----------------------------------------------------------------------------
  -- TWILIGHT: Dim inactive code
  -----------------------------------------------------------------------------
  {
    "folke/twilight.nvim",
    cmd = { "Twilight", "TwilightEnable" },
    opts = { dimming = { alpha = 0.25 }, context = 10, treesitter = true },
    keys = {
      { "<leader>ut", "<cmd>Twilight<cr>", desc = "Toggle Twilight" },
    },
  },

  -----------------------------------------------------------------------------
  -- OPEN-BROWSER: Open URLs with gx
  -----------------------------------------------------------------------------
  {
    "tyru/open-browser.vim",
    event = "VeryLazy",
    keys = {
      { "gx", "<Plug>(openbrowser-smart-search)", mode = { "n", "v" }, desc = "Open URL/Search" },
    },
    init = function()
      vim.g.netrw_nogx = 1
    end,
  },

  -----------------------------------------------------------------------------
  -- BULLETS: Auto-continue markdown lists
  -----------------------------------------------------------------------------
  {
    "dkarter/bullets.vim",
    ft = { "markdown", "text", "gitcommit" },
    init = function()
      vim.g.bullets_enabled_file_types = { "markdown", "text", "gitcommit", "scratch" }
      vim.g.bullets_enable_in_empty_buffers = 0
      vim.g.bullets_set_mappings = 1
    end,
  },

  -----------------------------------------------------------------------------
  -- RENDER-MARKDOWN: In-buffer markdown rendering
  -- Renders headings, code blocks, checkboxes, tables, links inline
  -----------------------------------------------------------------------------
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    ft = { "markdown", "norg", "org", "codecompanion" },
    opts = {
      heading = {
        enabled = true,
        sign = true,
        icons = { "# ", "## ", "### ", "#### ", "##### ", "###### " },
      },
      code = {
        enabled = true,
        sign = true,
        style = "full",
        left_pad = 1,
        right_pad = 1,
        language_pad = 1,
      },
      checkbox = {
        enabled = true,
        unchecked = { icon = " " },
        checked = { icon = " " },
      },
      bullet = { enabled = true },
      dash = { enabled = true },
      pipe_table = { enabled = true, style = "full" },
      link = { enabled = true },
    },
    keys = {
      { "<leader>um", function() require("render-markdown").toggle() end, desc = "Toggle Render Markdown" },
    },
  },

  -----------------------------------------------------------------------------
  -- MARKDOWN-PREVIEW: Live browser preview
  -----------------------------------------------------------------------------
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = "cd app && npm install",
    init = function()
      vim.g.mkdp_auto_close = 1
      vim.g.mkdp_open_to_the_world = 0
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    keys = {
      { "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", desc = "Markdown Preview" },
    },
  },

  -----------------------------------------------------------------------------
  -- DIFFVIEW: Git diff viewer
  -- Use <leader>gvd to avoid conflict with snacks git_diff on <leader>gd
  -----------------------------------------------------------------------------
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
    keys = {
      { "<leader>gvd", "<cmd>DiffviewOpen<cr>", desc = "Diffview Open" },
      { "<leader>gvD", "<cmd>DiffviewClose<cr>", desc = "Diffview Close" },
      { "<leader>gvh", "<cmd>DiffviewFileHistory %<cr>", desc = "File History" },
      { "<leader>gvH", "<cmd>DiffviewFileHistory<cr>", desc = "Branch History" },
    },
  },

  -----------------------------------------------------------------------------
  -- PRECOGNITION: Movement hints
  -----------------------------------------------------------------------------
  {
    "tris203/precognition.nvim",
    event = "VeryLazy",
    opts = { startVisible = true },
    keys = {
      { "<leader>up", function() require("precognition").toggle() end, desc = "Toggle Precognition" },
    },
  },

  -----------------------------------------------------------------------------
  -- VIM-BE-GOOD: Practice vim motions with mini-games
  -----------------------------------------------------------------------------
  {
    "ThePrimeagen/vim-be-good",
    cmd = "VimBeGood",
    keys = {
      { "<leader>uV", "<cmd>VimBeGood<cr>", desc = "Vim Be Good" },
    },
  },

  -----------------------------------------------------------------------------
  -- GOTO-PREVIEW: LSP definition/reference preview
  -----------------------------------------------------------------------------
  {
    "rmagatti/goto-preview",
    event = "LspAttach",
    opts = { width = 120, height = 25, default_mappings = false },
    keys = {
      { "gpd", function() require("goto-preview").goto_preview_definition() end, desc = "Preview Definition" },
      { "gpt", function() require("goto-preview").goto_preview_type_definition() end, desc = "Preview Type Def" },
      { "gpi", function() require("goto-preview").goto_preview_implementation() end, desc = "Preview Implementation" },
      { "gpr", function() require("goto-preview").goto_preview_references() end, desc = "Preview References" },
      { "gP", function() require("goto-preview").close_all_win() end, desc = "Close All Previews" },
    },
  },
}
