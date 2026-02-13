-- Editor plugins configuration
-- flash.nvim (default), gitsigns (default), snacks_explorer/picker (extras) handle core editing
-- Only custom overrides and additional plugins here
return {
  -----------------------------------------------------------------------------
  -- DIAL: Increment/decrement
  -----------------------------------------------------------------------------
  {
    "monaqa/dial.nvim",
    keys = {
      { "<C-a>", function() require("dial.map").manipulate("increment", "normal") end, desc = "Increment" },
      { "<C-x>", function() require("dial.map").manipulate("decrement", "normal") end, desc = "Decrement" },
      { "g<C-a>", function() require("dial.map").manipulate("increment", "gnormal") end, desc = "G-Increment" },
      { "g<C-x>", function() require("dial.map").manipulate("decrement", "gnormal") end, desc = "G-Decrement" },
      { "<C-a>", function() require("dial.map").manipulate("increment", "visual") end, mode = "v", desc = "Increment" },
      { "<C-x>", function() require("dial.map").manipulate("decrement", "visual") end, mode = "v", desc = "Decrement" },
      { "g<C-a>", function() require("dial.map").manipulate("increment", "gvisual") end, mode = "v", desc = "G-Increment" },
      { "g<C-x>", function() require("dial.map").manipulate("decrement", "gvisual") end, mode = "v", desc = "G-Decrement" },
    },
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
          augend.constant.new({ elements = { "true", "false" } }),
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
  -- HARPOON2: Quick file navigation
  -----------------------------------------------------------------------------
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      settings = {
        save_on_toggle = true,
        sync_on_ui_close = true,
        key = function()
          return vim.uv.cwd()
        end,
      },
    },
    keys = {
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
  -- ILLUMINATE: Highlight word under cursor
  -----------------------------------------------------------------------------
  {
    "RRethy/vim-illuminate",
    opts = {
      delay = 200,
      large_file_cutoff = 2000,
      large_file_overrides = {
        providers = { "lsp" },
      },
      filetypes_denylist = {
        "dirbuf", "dirvish", "fugitive", "alpha",
        "lazy", "mason", "minifiles", "Trouble",
        "dashboard", "snacks_picker", "help", "terminal",
      },
      under_cursor = true,
      min_count_to_highlight = 2,
    },
  },

  -----------------------------------------------------------------------------
  -- INC-RENAME: Incremental LSP renaming
  -----------------------------------------------------------------------------
  {
    "smjonas/inc-rename.nvim",
    dependencies = { "folke/noice.nvim" },
    opts = {
      input_buffer_type = nil,
    },
    keys = {
      { "<leader>cr", function()
        return ":IncRename " .. vim.fn.expand("<cword>")
      end, expr = true, desc = "Rename (inc)" },
    },
  },

  -----------------------------------------------------------------------------
  -- MINI.FILES: File explorer
  -----------------------------------------------------------------------------
  {
    "nvim-mini/mini.files",
    opts = {
      windows = {
        preview = true,
        width_focus = 30,
        width_preview = 50,
      },
      options = {
        use_as_default_explorer = false, -- snacks_explorer is default
        permanent_delete = false,
      },
      mappings = {
        close = "q",
        go_in = "l",
        go_in_plus = "<CR>",
        go_out = "h",
        go_out_plus = "H",
        reset = "<BS>",
        reveal_cwd = "@",
        show_help = "g?",
        synchronize = "=",
        trim_left = "<",
        trim_right = ">",
      },
    },
    keys = {
      { "<leader>fm", function() require("mini.files").open(vim.api.nvim_buf_get_name(0), true) end, desc = "Mini Files (file)" },
      { "<leader>fM", function() require("mini.files").open(vim.uv.cwd(), true) end, desc = "Mini Files (cwd)" },
      { "-", function() require("mini.files").open(vim.api.nvim_buf_get_name(0), true) end, desc = "Open Mini Files" },
    },
  },

  -----------------------------------------------------------------------------
  -- MINI.MOVE: Move lines/blocks
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
      options = {
        reindent_linewise = true,
      },
    },
    keys = {
      { "<M-h>", mode = { "n", "v" }, desc = "Move Left" },
      { "<M-j>", mode = { "n", "v" }, desc = "Move Down" },
      { "<M-k>", mode = { "n", "v" }, desc = "Move Up" },
      { "<M-l>", mode = { "n", "v" }, desc = "Move Right" },
    },
  },

  -----------------------------------------------------------------------------
  -- NAVIC: Breadcrumbs
  -----------------------------------------------------------------------------
  {
    "SmiteshP/nvim-navic",
    lazy = true,
    opts = {
      separator = " > ",
      highlight = true,
      depth_limit = 5,
      depth_limit_indicator = "...",
      safe_output = true,
      lazy_update_context = true,
      click = true,
    },
    init = function()
      vim.g.navic_silence = true
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          local buffer = args.buf
          if client and client.supports_method("textDocument/documentSymbol") then
            require("nvim-navic").attach(client, buffer)
          end
        end,
      })
    end,
  },

  -----------------------------------------------------------------------------
  -- OUTLINE: Code outline view
  -----------------------------------------------------------------------------
  {
    "hedyhli/outline.nvim",
    opts = {
      outline_window = {
        position = "right",
        width = 30,
        relative_width = false,
        auto_close = false,
        auto_jump = false,
        show_cursorline = true,
        hide_cursor = true,
      },
      preview_window = {
        auto_preview = true,
        open_hover_on_preview = true,
        width = 50,
        min_width = 50,
        relative_width = true,
        border = "rounded",
      },
      symbol_folding = {
        autofold_depth = 1,
        auto_unfold = { hovered = true },
        markers = { "", "" },
      },
      keymaps = {
        close = { "<Esc>", "q" },
        goto_location = "<CR>",
        peek_location = "o",
        goto_and_close = "<S-CR>",
        restore_location = "<C-g>",
        hover_symbol = "K",
        toggle_preview = "p",
        rename_symbol = "r",
        code_actions = "a",
        fold = "h",
        unfold = "l",
        fold_toggle = "<Tab>",
        fold_toggle_all = "<S-Tab>",
        fold_all = "W",
        unfold_all = "E",
        fold_reset = "R",
        down_and_jump = "<C-j>",
        up_and_jump = "<C-k>",
      },
    },
    keys = {
      { "<leader>co", "<cmd>Outline<cr>", desc = "Toggle Outline" },
    },
  },

  -----------------------------------------------------------------------------
  -- OVERSEER: Task runner
  -----------------------------------------------------------------------------
  {
    "stevearc/overseer.nvim",
    opts = {
      strategy = "terminal",
      templates = { "builtin" },
      task_list = {
        direction = "bottom",
        min_height = 10,
        max_height = 20,
        default_detail = 1,
        bindings = {
          ["?"] = "ShowHelp",
          ["g?"] = "ShowHelp",
          ["<CR>"] = "RunAction",
          ["<C-e>"] = "Edit",
          ["o"] = "Open",
          ["<C-v>"] = "OpenVsplit",
          ["<C-s>"] = "OpenSplit",
          ["<C-f>"] = "OpenFloat",
          ["<C-q>"] = "OpenQuickFix",
          ["p"] = "TogglePreview",
          ["<C-l>"] = "IncreaseDetail",
          ["<C-h>"] = "DecreaseDetail",
          ["L"] = "IncreaseAllDetail",
          ["H"] = "DecreaseAllDetail",
          ["["] = "DecreaseWidth",
          ["]"] = "IncreaseWidth",
          ["{"] = "PrevTask",
          ["}"] = "NextTask",
          ["<C-k>"] = "ScrollOutputUp",
          ["<C-j>"] = "ScrollOutputDown",
          ["q"] = "Close",
        },
      },
      component_aliases = {
        default = {
          { "display_duration", detail_level = 2 },
          "on_output_summarize",
          "on_exit_set_status",
          "on_complete_notify",
          "on_complete_dispose",
        },
      },
      dap = true,
    },
    keys = {
      { "<leader>ot", "<cmd>OverseerToggle<cr>", desc = "Overseer Toggle" },
      { "<leader>or", "<cmd>OverseerRun<cr>", desc = "Overseer Run" },
      { "<leader>oR", "<cmd>OverseerRunCmd<cr>", desc = "Overseer Run Cmd" },
      { "<leader>ob", "<cmd>OverseerBuild<cr>", desc = "Overseer Build" },
      { "<leader>oq", "<cmd>OverseerQuickAction<cr>", desc = "Overseer Quick Action" },
      { "<leader>oa", "<cmd>OverseerTaskAction<cr>", desc = "Overseer Task Action" },
      { "<leader>oi", "<cmd>OverseerInfo<cr>", desc = "Overseer Info" },
      { "<leader>oc", "<cmd>OverseerClearCache<cr>", desc = "Overseer Clear Cache" },
    },
  },

  -----------------------------------------------------------------------------
  -- REFACTORING: Code refactoring
  -----------------------------------------------------------------------------
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      prompt_func_return_type = {
        go = true,
        cpp = true,
        c = true,
        java = true,
      },
      prompt_func_param_type = {
        go = true,
        cpp = true,
        c = true,
        java = true,
      },
      printf_statements = {},
      print_var_statements = {},
      show_success_message = true,
    },
    keys = {
      { "<leader>re", function() require("refactoring").refactor("Extract Function") end, mode = "x", desc = "Extract Function" },
      { "<leader>rf", function() require("refactoring").refactor("Extract Function To File") end, mode = "x", desc = "Extract to File" },
      { "<leader>rv", function() require("refactoring").refactor("Extract Variable") end, mode = "x", desc = "Extract Variable" },
      { "<leader>rI", function() require("refactoring").refactor("Inline Function") end, desc = "Inline Function" },
      { "<leader>ri", function() require("refactoring").refactor("Inline Variable") end, mode = { "n", "x" }, desc = "Inline Variable" },
      { "<leader>rb", function() require("refactoring").refactor("Extract Block") end, desc = "Extract Block" },
      { "<leader>rB", function() require("refactoring").refactor("Extract Block To File") end, desc = "Extract Block to File" },
      { "<leader>rr", function() require("refactoring").select_refactor() end, mode = { "n", "x" }, desc = "Select Refactor" },
      { "<leader>rp", function() require("refactoring").debug.printf({ below = true }) end, desc = "Debug Printf" },
      { "<leader>rP", function() require("refactoring").debug.print_var() end, mode = { "n", "x" }, desc = "Debug Print Var" },
      { "<leader>rc", function() require("refactoring").debug.cleanup() end, desc = "Debug Cleanup" },
    },
  },

  -----------------------------------------------------------------------------
  -- SNACKS: Custom overrides only (explorer/picker/notifier/etc from extras)
  -- Only adding settings that differ from LazyVim defaults
  -----------------------------------------------------------------------------
  {
    "folke/snacks.nvim",
    opts = {
      zen = {
        toggles = { dim = true, git_signs = false, diagnostics = false },
      },
      scroll = { enabled = false },
      indent = { enabled = false },
    },
    keys = {
      -- Zen
      { "<leader>z", function() Snacks.zen() end, desc = "Zen Mode" },
      { "<leader>Z", function() Snacks.zen.zoom() end, desc = "Zoom" },
    },
  },
}
