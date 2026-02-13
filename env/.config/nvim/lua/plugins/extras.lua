-- Quality of Life plugins
return {
  -----------------------------------------------------------------------------
  -- GRUG-FAR: Project-wide search and replace
  -----------------------------------------------------------------------------
  {
    "MagicDuck/grug-far.nvim",
    opts = { headerMaxWidth = 80 },
    cmd = "GrugFar",
    keys = {
      { "<leader>sr", function() require("grug-far").open({ transient = true }) end, desc = "Search and Replace" },
      { "<leader>sr", function() require("grug-far").open({ transient = true, prefills = { search = vim.fn.expand("<cword>") } }) end, mode = "v", desc = "Replace Selection" },
      { "<leader>sR", function() require("grug-far").open({ transient = true, prefills = { paths = vim.fn.expand("%") } }) end, desc = "Replace in File" },
    },
  },

  -----------------------------------------------------------------------------
  -- BQF: Better quickfix
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
        border = "rounded",
        show_title = true,
        should_preview_cb = function(bufnr)
          local ret = true
          local bufname = vim.api.nvim_buf_get_name(bufnr)
          local fsize = vim.fn.getfsize(bufname)
          if fsize > 100 * 1024 then ret = false end
          if bufname:match("^fugitive://") then ret = false end
          return ret
        end,
      },
      func_map = {
        open = "<cr>",
        openc = "o",
        drop = "O",
        split = "<C-s>",
        vsplit = "<C-v>",
        tab = "t",
        tabb = "T",
        tabc = "<C-t>",
        tabdrop = "",
        ptogglemode = "z,",
        ptoggleitem = "p",
        ptoggleauto = "P",
        pscrollup = "<C-b>",
        pscrolldown = "<C-f>",
        fzffilter = "zf",
        prevfile = "<C-p>",
        nextfile = "<C-n>",
        prevhist = "<",
        nexthist = ">",
        lastleave = "'\"",
        stoggleup = "<S-Tab>",
        stoggledown = "<Tab>",
        stogglevm = "<Tab>",
        stogglebuf = "'<Tab>",
        sclear = "z<Tab>",
        filter = "zn",
        filterr = "zN",
      },
      filter = {
        fzf = {
          action_for = { ["ctrl-s"] = "split", ["ctrl-v"] = "vsplit", ["ctrl-t"] = "tab drop" },
          extra_opts = { "--bind", "ctrl-o:toggle-all", "--prompt", "> ", "--delimiter", "|" },
        },
      },
    },
  },

  -----------------------------------------------------------------------------
  -- RAINBOW-DELIMITERS: Colorful brackets
  -----------------------------------------------------------------------------
  {
    "HiPhish/rainbow-delimiters.nvim",
    event = "VeryLazy",
    config = function()
      local rainbow = require("rainbow-delimiters")
      vim.g.rainbow_delimiters = {
        strategy = {
          [""] = rainbow.strategy["global"],
          vim = rainbow.strategy["local"],
        },
        query = {
          [""] = "rainbow-delimiters",
          lua = "rainbow-blocks",
        },
        priority = {
          [""] = 110,
          lua = 210,
        },
        highlight = {
          "RainbowDelimiterRed",
          "RainbowDelimiterYellow",
          "RainbowDelimiterBlue",
          "RainbowDelimiterOrange",
          "RainbowDelimiterGreen",
          "RainbowDelimiterViolet",
          "RainbowDelimiterCyan",
        },
      }
    end,
  },

  -----------------------------------------------------------------------------
  -- HLSLENS: Search count and current match
  -----------------------------------------------------------------------------
  {
    "kevinhwang91/nvim-hlslens",
    event = "VeryLazy",
    opts = {
      calm_down = true,
      nearest_only = false,
      nearest_float_when = "auto",
    },
    config = function(_, opts)
      require("hlslens").setup(opts)

      local map = vim.keymap.set
      map("n", "n", [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR>zz<Cmd>lua require('hlslens').start()<CR>]], { desc = "Next match" })
      map("n", "N", [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR>zz<Cmd>lua require('hlslens').start()<CR>]], { desc = "Prev match" })
      map("n", "*", [[*<Cmd>lua require('hlslens').start()<CR>]], { desc = "Search word forward" })
      map("n", "#", [[#<Cmd>lua require('hlslens').start()<CR>]], { desc = "Search word backward" })
      map("n", "g*", [[g*<Cmd>lua require('hlslens').start()<CR>]], { desc = "Search word forward (partial)" })
      map("n", "g#", [[g#<Cmd>lua require('hlslens').start()<CR>]], { desc = "Search word backward (partial)" })
    end,
  },

  -----------------------------------------------------------------------------
  -- GIT-CONFLICT: Merge conflict helper
  -----------------------------------------------------------------------------
  {
    "akinsho/git-conflict.nvim",
    version = "*",
    event = "VeryLazy",
    opts = {
      default_mappings = true,
      default_commands = true,
      disable_diagnostics = false,
      list_opener = "copen",
      highlights = {
        incoming = "DiffAdd",
        current = "DiffText",
      },
    },
    keys = {
      { "<leader>gco", "<cmd>GitConflictChooseOurs<cr>", desc = "Choose Ours" },
      { "<leader>gct", "<cmd>GitConflictChooseTheirs<cr>", desc = "Choose Theirs" },
      { "<leader>gcb", "<cmd>GitConflictChooseBoth<cr>", desc = "Choose Both" },
      { "<leader>gc0", "<cmd>GitConflictChooseNone<cr>", desc = "Choose None" },
      { "[x", "<cmd>GitConflictPrevConflict<cr>", desc = "Prev Conflict" },
      { "]x", "<cmd>GitConflictNextConflict<cr>", desc = "Next Conflict" },
    },
  },

  -----------------------------------------------------------------------------
  -- BETTER-ESCAPE: jk/jj without delay
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
  -- LSPSAGA: Better code actions UI
  -----------------------------------------------------------------------------
  {
    "nvimdev/lspsaga.nvim",
    event = "LspAttach",
    opts = {
      symbol_in_winbar = { enable = false },
      lightbulb = { enable = false },
      outline = { enable = false },
      code_action = {
        num_shortcut = true,
        show_server_name = true,
        extend_gitsigns = true,
      },
      finder = {
        max_height = 0.6,
        left_width = 0.3,
        right_width = 0.5,
        default = "def+ref+imp",
        keys = {
          toggle_or_open = "<CR>",
          vsplit = "v",
          split = "s",
          tabnew = "t",
          quit = "q",
          close = "<ESC>",
        },
      },
      hover = {
        max_width = 0.6,
        max_height = 0.6,
      },
      ui = {
        border = "rounded",
        devicon = true,
        title = true,
      },
    },
    keys = {
      { "K", "<cmd>Lspsaga hover_doc<cr>", desc = "Hover Doc" },
      { "<leader>ca", "<cmd>Lspsaga code_action<cr>", mode = { "n", "v" }, desc = "Code Action" },
      { "<leader>cA", "<cmd>Lspsaga finder<cr>", desc = "LSP Finder" },
      { "<leader>cp", "<cmd>Lspsaga peek_definition<cr>", desc = "Peek Definition" },
      { "<leader>cD", "<cmd>Lspsaga peek_type_definition<cr>", desc = "Peek Type Definition" },
    },
  },

  -----------------------------------------------------------------------------
  -- FLASH: Only custom treesitter keymaps (LazyVim handles s/S/f/t defaults)
  -----------------------------------------------------------------------------
  {
    "folke/flash.nvim",
    opts = {
      label = {
        rainbow = { enabled = true, shade = 5 },
      },
      modes = {
        search = { enabled = false },
      },
    },
    keys = {
      { "S", function() require("flash").treesitter() end, mode = { "n", "x", "o" }, desc = "Flash Treesitter" },
      { "r", function() require("flash").remote() end, mode = "o", desc = "Remote Flash" },
      { "R", function() require("flash").treesitter_search() end, mode = { "o", "x" }, desc = "Treesitter Search" },
    },
  },

  -----------------------------------------------------------------------------
  -- WINDOWS: Auto-resize focused window
  -----------------------------------------------------------------------------
  {
    "anuvyklack/windows.nvim",
    event = "WinNew",
    dependencies = { "anuvyklack/middleclass" },
    opts = {
      autowidth = {
        enable = true,
        winwidth = 10,
        filetype = {
          help = 2,
        },
      },
      ignore = {
        buftype = { "quickfix" },
        filetype = { "undotree", "gundo", "Outline", "trouble", "minifiles", "snacks_explorer" },
      },
      animation = {
        enable = false,
      },
    },
    keys = {
      { "<leader>wm", "<cmd>WindowsMaximize<cr>", desc = "Maximize Window" },
      { "<leader>w=", "<cmd>WindowsEqualize<cr>", desc = "Equalize Windows" },
    },
  },
}
