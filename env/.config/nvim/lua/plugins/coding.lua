-- Coding plugins configuration
-- blink.cmp and mini-snippets are handled by LazyVim extras
return {
  -----------------------------------------------------------------------------
  -- NVIM-AUTOPAIRS: Auto-close brackets/quotes
  -----------------------------------------------------------------------------
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      check_ts = true,
      ts_config = {
        lua = { "string", "source" },
        javascript = { "string", "template_string" },
        typescript = { "string", "template_string" },
      },
      disable_filetype = { "snacks_picker", "grug-far", "vim" },
      fast_wrap = {
        map = "<M-e>",
        chars = { "{", "[", "(", '"', "'" },
        pattern = [=[[%'%"%>%]%)%}%,]]=],
        end_key = "$",
        before_key = "h",
        after_key = "l",
        cursor_pos_before = true,
        keys = "qwertyuiopzxcvbnmasdfghjkl",
        check_comma = true,
        manual_position = true,
        highlight = "Search",
        highlight_grey = "Comment",
      },
      enable_check_bracket_line = true,
      enable_bracket_in_quote = true,
      enable_abbr = false,
      break_undo = true,
      map_cr = true,
      map_bs = true,
      map_c_h = false,
      map_c_w = false,
    },
  },

  -----------------------------------------------------------------------------
  -- NVIM-TS-AUTOTAG: Auto-close/rename HTML tags
  -----------------------------------------------------------------------------
  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    opts = {
      opts = {
        enable_close = true,
        enable_rename = true,
        enable_close_on_slash = true,
      },
      filetypes = {
        "html", "xml", "javascript", "javascriptreact", "typescript", "typescriptreact",
        "svelte", "vue", "tsx", "jsx", "rescript", "php", "markdown", "astro", "glimmer", "handlebars",
      },
    },
  },

  -----------------------------------------------------------------------------
  -- MINI.SURROUND: Surround operations
  -----------------------------------------------------------------------------
  {
    "nvim-mini/mini.surround",
    event = "VeryLazy",
    opts = {
      mappings = {
        add = "gsa",
        delete = "gsd",
        find = "gsf",
        find_left = "gsF",
        highlight = "gsh",
        replace = "gsr",
        update_n_lines = "gsn",
        suffix_last = "l",
        suffix_next = "n",
      },
      n_lines = 50,
      respect_selection_type = false,
      search_method = "cover_or_next",
      silent = false,
    },
  },

  -----------------------------------------------------------------------------
  -- NEOGEN: Documentation generator
  -----------------------------------------------------------------------------
  {
    "danymat/neogen",
    dependencies = "nvim-treesitter/nvim-treesitter",
    opts = {
      enabled = true,
      snippet_engine = "mini",
      languages = {
        python = { template = { annotation_convention = "google_docstrings" } },
        javascript = { template = { annotation_convention = "jsdoc" } },
        typescript = { template = { annotation_convention = "tsdoc" } },
        lua = { template = { annotation_convention = "emmylua" } },
        go = { template = { annotation_convention = "godoc" } },
      },
    },
    keys = {
      { "<leader>cg", function() require("neogen").generate() end, desc = "Generate Docs" },
    },
  },

  -----------------------------------------------------------------------------
  -- YANKY: Enhanced yank/paste
  -- Use [y/]y for cycling to avoid C-p/C-n conflicts with completion
  -----------------------------------------------------------------------------
  {
    "gbprod/yanky.nvim",
    event = "VeryLazy",
    opts = {
      ring = {
        history_length = 100,
        storage = "shada",
        sync_with_numbered_registers = true,
        cancel_event = "update",
        ignore_registers = { "_" },
      },
      system_clipboard = { sync_with_ring = true },
      highlight = { on_put = true, on_yank = true, timer = 200 },
      preserve_cursor_position = { enabled = true },
    },
    keys = {
      { "y", "<Plug>(YankyYank)", mode = { "n", "x" }, desc = "Yank" },
      { "p", "<Plug>(YankyPutAfter)", desc = "Put After" },
      { "P", "<Plug>(YankyPutBefore)", desc = "Put Before" },
      { "[y", "<Plug>(YankyPreviousEntry)", desc = "Prev Yank" },
      { "]y", "<Plug>(YankyNextEntry)", desc = "Next Yank" },
    },
  },

  -----------------------------------------------------------------------------
  -- MINI.AI: Enhanced text objects
  -----------------------------------------------------------------------------
  {
    "nvim-mini/mini.ai",
    event = "VeryLazy",
    opts = function()
      local ai = require("mini.ai")
      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
          t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().googletag.display$" },
          d = { "%f[%d]%d+" },
          e = {
            { "%u[%l%d]+%f[^%l%d]", "%f[%S][%l%d]+%f[^%l%d]", "%f[%P][%l%d]+%f[^%l%d]", "^[%l%d]+%f[^%l%d]" },
            "^().*googletag.display$",
          },
          u = ai.gen_spec.function_call(),
          U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }),
        },
      }
    end,
  },

  -----------------------------------------------------------------------------
  -- MINI.SNIPPETS: Explicit snippet configuration
  -- LazyVim extra loads mini.snippets; this extends it with custom paths
  -----------------------------------------------------------------------------
  {
    "nvim-mini/mini.snippets",
    opts = function(_, opts)
      local snippets = require("mini.snippets")
      opts.snippets = opts.snippets or {}
      -- Load built-in snippets from friendly-snippets
      table.insert(opts.snippets, snippets.gen_loader.from_lang())
      -- Load custom snippets from ~/.config/nvim/snippets/ if the dir exists
      local custom_dir = vim.fn.stdpath("config") .. "/snippets"
      if vim.fn.isdirectory(custom_dir) == 1 then
        table.insert(opts.snippets, snippets.gen_loader.from_file(custom_dir))
      end
    end,
  },

  -----------------------------------------------------------------------------
  -- TREESITTER-TEXTOBJECTS: Handled by LazyVim
  -----------------------------------------------------------------------------
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    enabled = false,
  },
}
