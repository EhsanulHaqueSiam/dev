-- Editor: motion, navigation, windows, search.
--
-- LazyVim extras already install and key-bind dial, harpoon2, illuminate,
-- inc-rename, mini-files, mini-move, navic, outline, overseer, refactoring and
-- the snacks picker/explorer. Anything below is either an opts-only tweak on
-- top of an extra, or a plugin no extra provides.
return {
  -----------------------------------------------------------------------------
  -- DIAL: <C-a>/<C-x> that understands more than integers
  -----------------------------------------------------------------------------
  {
    "monaqa/dial.nvim",
    config = function()
      local augend = require("dial.augend")
      require("dial.config").augends:register_group({
        default = {
          augend.integer.alias.decimal_int,
          augend.integer.alias.hex,
          augend.integer.alias.octal,
          augend.integer.alias.binary,
          augend.date.alias["%Y/%m/%d"],
          augend.date.alias["%Y-%m-%d"],
          augend.date.alias["%d.%m.%Y"],
          augend.date.alias["%H:%M:%S"],
          augend.date.alias["%H:%M"],
          augend.constant.alias.bool,
          augend.semver.alias.semver,
          augend.constant.new({ elements = { "True", "False" } }),
          augend.constant.new({ elements = { "TRUE", "FALSE" } }),
          augend.constant.new({ elements = { "yes", "no" } }),
          augend.constant.new({ elements = { "on", "off" } }),
          augend.constant.new({ elements = { "and", "or" } }),
          augend.constant.new({ elements = { "&&", "||" } }),
          augend.constant.new({ elements = { "let", "const", "var" } }),
          augend.constant.new({ elements = { "public", "private", "protected" } }),
          augend.constant.new({ elements = { "==", "!=" } }),
          augend.constant.new({ elements = { "===", "!==" } }),
          augend.constant.new({ elements = { "first", "last" } }),
          augend.constant.new({ elements = { "before", "after" } }),
          augend.constant.new({ elements = { "min", "max" } }),
          augend.constant.new({ elements = { "asc", "desc" } }),
          augend.constant.new({ elements = { "top", "bottom", "left", "right" } }),
          augend.constant.new({ elements = { "get", "post", "put", "patch", "delete" } }),
          augend.constant.new({ elements = { "GET", "POST", "PUT", "PATCH", "DELETE" } }),
        },
      })
    end,
  },

  -----------------------------------------------------------------------------
  -- HARPOON
  -- Everything lives under <leader>h. LazyVim's extra puts the menu on bare
  -- <leader>h, which the which-key group would shadow, so that one is disabled.
  -----------------------------------------------------------------------------
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    opts = {
      settings = {
        save_on_toggle = true,
        sync_on_ui_close = true,
        key = function()
          return vim.uv.cwd()
        end,
      },
    },
    -- stylua: ignore
    keys = {
      { "<leader>h", false },
      { "<leader>ha", function() require("harpoon"):list():add() end, desc = "Harpoon Add" },
      { "<leader>hh", function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end, desc = "Harpoon Menu" },
      { "<leader>h1", function() require("harpoon"):list():select(1) end, desc = "Harpoon File 1" },
      { "<leader>h2", function() require("harpoon"):list():select(2) end, desc = "Harpoon File 2" },
      { "<leader>h3", function() require("harpoon"):list():select(3) end, desc = "Harpoon File 3" },
      { "<leader>h4", function() require("harpoon"):list():select(4) end, desc = "Harpoon File 4" },
      { "<leader>h5", function() require("harpoon"):list():select(5) end, desc = "Harpoon File 5" },
      { "<leader>hp", function() require("harpoon"):list():prev() end, desc = "Harpoon Prev" },
      { "<leader>hn", function() require("harpoon"):list():next() end, desc = "Harpoon Next" },
      { "<M-1>", function() require("harpoon"):list():select(1) end, desc = "Harpoon 1" },
      { "<M-2>", function() require("harpoon"):list():select(2) end, desc = "Harpoon 2" },
      { "<M-3>", function() require("harpoon"):list():select(3) end, desc = "Harpoon 3" },
      { "<M-4>", function() require("harpoon"):list():select(4) end, desc = "Harpoon 4" },
    },
  },

  -----------------------------------------------------------------------------
  -- ILLUMINATE
  -----------------------------------------------------------------------------
  {
    "RRethy/vim-illuminate",
    opts = {
      delay = 200,
      large_file_cutoff = 2000,
      large_file_overrides = { providers = { "lsp" } },
      under_cursor = true,
      min_count_to_highlight = 2,
    },
  },

  -----------------------------------------------------------------------------
  -- MINI.FILES: `-` opens the directory of the current file
  -----------------------------------------------------------------------------
  {
    "nvim-mini/mini.files",
    opts = {
      windows = { preview = true, width_focus = 30, width_preview = 50 },
      options = {
        use_as_default_explorer = false, -- snacks explorer is the default
        permanent_delete = false,
      },
    },
    -- stylua: ignore
    keys = {
      { "-", function() require("mini.files").open(vim.api.nvim_buf_get_name(0), true) end, desc = "Open Mini Files" },
    },
  },

  -----------------------------------------------------------------------------
  -- MINI.MOVE: <M-hjkl> moves the line or selection
  -----------------------------------------------------------------------------
  {
    "nvim-mini/mini.move",
    opts = {
      mappings = {
        left = "<M-h>",
        right = "<M-l>",
        down = "<M-j>",
        up = "<M-k>",
        line_left = "<M-h>",
        line_right = "<M-l>",
        line_down = "<M-j>",
        line_up = "<M-k>",
      },
      options = { reindent_linewise = true },
    },
  },

  -----------------------------------------------------------------------------
  -- OUTLINE (<leader>cs from the LazyVim extra)
  -----------------------------------------------------------------------------
  {
    "hedyhli/outline.nvim",
    opts = {
      outline_window = {
        position = "right",
        width = 30,
        relative_width = false,
        auto_close = false,
        show_cursorline = true,
        hide_cursor = true,
      },
      preview_window = { auto_preview = true, open_hover_on_preview = true },
      symbol_folding = { autofold_depth = 1, auto_unfold = { hovered = true } },
    },
  },

  -----------------------------------------------------------------------------
  -- OVERSEER (<leader>ow / oo / ot from the LazyVim extra)
  -----------------------------------------------------------------------------
  {
    "stevearc/overseer.nvim",
    opts = {
      strategy = "terminal",
      task_list = { direction = "bottom", min_height = 10, max_height = 20 },
      dap = true,
    },
  },

  -----------------------------------------------------------------------------
  -- FLASH: LazyVim binds s/S/f/t; these add the treesitter + remote modes
  -----------------------------------------------------------------------------
  {
    "folke/flash.nvim",
    opts = {
      label = { rainbow = { enabled = true, shade = 5 } },
      modes = { search = { enabled = false } }, -- hlslens owns / and ?
    },
    -- stylua: ignore
    keys = {
      { "S", function() require("flash").treesitter() end, mode = { "n", "x", "o" }, desc = "Flash Treesitter" },
      { "r", function() require("flash").remote() end, mode = "o", desc = "Remote Flash" },
      { "R", function() require("flash").treesitter_search() end, mode = { "o", "x" }, desc = "Treesitter Search" },
    },
  },

  -----------------------------------------------------------------------------
  -- HLSLENS: match count next to the cursor while searching
  -----------------------------------------------------------------------------
  {
    "kevinhwang91/nvim-hlslens",
    event = "VeryLazy",
    opts = { calm_down = true, nearest_only = false, nearest_float_when = "auto" },
    config = function(_, opts)
      require("hlslens").setup(opts)
      local map = vim.keymap.set
      -- stylua: ignore start
      map("n", "n", [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR>zz<Cmd>lua require('hlslens').start()<CR>]], { desc = "Next match" })
      map("n", "N", [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR>zz<Cmd>lua require('hlslens').start()<CR>]], { desc = "Prev match" })
      map("n", "*",  [[*<Cmd>lua require('hlslens').start()<CR>]],  { desc = "Search word forward" })
      map("n", "#",  [[#<Cmd>lua require('hlslens').start()<CR>]],  { desc = "Search word backward" })
      map("n", "g*", [[g*<Cmd>lua require('hlslens').start()<CR>]], { desc = "Search word forward (partial)" })
      map("n", "g#", [[g#<Cmd>lua require('hlslens').start()<CR>]], { desc = "Search word backward (partial)" })
      -- stylua: ignore end
    end,
  },

  -----------------------------------------------------------------------------
  -- BQF: preview + fzf filtering inside the quickfix window
  -----------------------------------------------------------------------------
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    opts = {
      auto_enable = true,
      auto_resize_height = true,
      preview = {
        win_height = 12,
        win_vheight = 12,
        delay_syntax = 80,
        show_title = true,
        should_preview_cb = function(bufnr)
          local bufname = vim.api.nvim_buf_get_name(bufnr)
          return vim.fn.getfsize(bufname) <= 100 * 1024 and not bufname:match("^fugitive://")
        end,
      },
    },
  },

  -----------------------------------------------------------------------------
  -- GRUG-FAR: LazyVim binds <leader>sr; this adds the current-file variant
  -----------------------------------------------------------------------------
  {
    "MagicDuck/grug-far.nvim",
    -- stylua: ignore
    keys = {
      { "<leader>sR", function() require("grug-far").open({ transient = true, prefills = { paths = vim.fn.expand("%") } }) end, desc = "Search and Replace (file)" },
    },
  },

  -----------------------------------------------------------------------------
  -- GOTO-PREVIEW: peek definitions in a float instead of jumping
  -----------------------------------------------------------------------------
  {
    "rmagatti/goto-preview",
    event = "LspAttach",
    opts = { width = 120, height = 25, default_mappings = false },
    -- stylua: ignore
    keys = {
      { "gpd", function() require("goto-preview").goto_preview_definition() end, desc = "Preview Definition" },
      { "gpt", function() require("goto-preview").goto_preview_type_definition() end, desc = "Preview Type Def" },
      { "gpi", function() require("goto-preview").goto_preview_implementation() end, desc = "Preview Implementation" },
      { "gpr", function() require("goto-preview").goto_preview_references() end, desc = "Preview References" },
      { "gP",  function() require("goto-preview").close_all_win() end, desc = "Close All Previews" },
    },
  },

  -----------------------------------------------------------------------------
  -- UNDOTREE
  -----------------------------------------------------------------------------
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    keys = { { "<leader>uu", "<cmd>UndotreeToggle<cr>", desc = "Undo Tree" } },
    init = function()
      vim.g.undotree_WindowLayout = 2
      vim.g.undotree_ShortIndicators = 1
      vim.g.undotree_SplitWidth = 30
      vim.g.undotree_DiffpanelHeight = 10
      vim.g.undotree_SetFocusWhenToggle = 1
      vim.g.undotree_DiffAutoOpen = 1
      vim.g.undotree_HighlightChangedText = 1
      vim.g.undotree_HelpLine = 0
    end,
  },

  -----------------------------------------------------------------------------
  -- TREESJ: split / join argument lists, tables, objects
  -----------------------------------------------------------------------------
  {
    "Wansmer/treesj",
    opts = { use_default_keymaps = false, max_join_length = 150 },
    -- stylua: ignore
    keys = {
      { "<leader>cj", function() require("treesj").toggle() end, desc = "Split/Join Toggle" },
      { "<leader>cJ", function() require("treesj").toggle({ split = { recursive = true } }) end, desc = "Split/Join Recursive" },
    },
  },

  -----------------------------------------------------------------------------
  -- MARKS: show marks in the sign column, m] / m[ to cycle
  -----------------------------------------------------------------------------
  {
    "chentoast/marks.nvim",
    event = "VeryLazy",
    opts = {
      default_mappings = true,
      builtin_marks = { ".", "<", ">", "^" },
      cyclic = true,
      sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20 },
      mappings = {
        set_next = "m,",
        next = "m]",
        prev = "m[",
        preview = "m:",
        delete_line = "dm-",
        delete_buf = "dm<space>",
      },
    },
  },

  -----------------------------------------------------------------------------
  -- MATCHUP: % across keywords (if/end, do/done, tags), off-screen match popup
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
  -- BETTER-ESCAPE: jk / jj without the timeoutlen pause
  -----------------------------------------------------------------------------
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    opts = {
      timeout = 200,
      default_mappings = false,
      mappings = {
        i = { j = { k = "<Esc>", j = "<Esc>" } },
        c = { j = { k = "<Esc>", j = "<Esc>" } },
        t = { j = { k = "<C-\\><C-n>" } },
        v = { j = { k = "<Esc>" } },
        s = { j = { k = "<Esc>" } },
      },
    },
  },

  -----------------------------------------------------------------------------
  -- VIM-BE-GOOD: motion drills
  -----------------------------------------------------------------------------
  {
    "ThePrimeagen/vim-be-good",
    cmd = "VimBeGood",
    keys = { { "<leader>uV", "<cmd>VimBeGood<cr>", desc = "Vim Be Good" } },
  },
}
