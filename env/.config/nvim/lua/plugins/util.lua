-- Utility plugins configuration
return {
  -----------------------------------------------------------------------------
  -- GITSIGNS: Git signs in gutter + git operations
  -----------------------------------------------------------------------------
  {
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy",
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      signs_staged = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
      },
      signcolumn = true,
      numhl = false,
      linehl = false,
      word_diff = false,
      watch_gitdir = { follow_files = true },
      auto_attach = true,
      attach_to_untracked = true,
      current_line_blame = false,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol",
        delay = 500,
        ignore_whitespace = false,
      },
      current_line_blame_formatter = "<author>, <author_time:%R> - <summary>",
      sign_priority = 6,
      update_debounce = 100,
      max_file_length = 40000,
      preview_config = { border = "rounded", style = "minimal", relative = "cursor", row = 0, col = 1 },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        map("n", "]h", function()
          if vim.wo.diff then return "]c" end
          vim.schedule(function() gs.next_hunk() end)
          return "<Ignore>"
        end, { expr = true, desc = "Next Hunk" })

        map("n", "[h", function()
          if vim.wo.diff then return "[c" end
          vim.schedule(function() gs.prev_hunk() end)
          return "<Ignore>"
        end, { expr = true, desc = "Prev Hunk" })

        map("n", "<leader>ghs", gs.stage_hunk, { desc = "Stage Hunk" })
        map("n", "<leader>ghr", gs.reset_hunk, { desc = "Reset Hunk" })
        map("v", "<leader>ghs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, { desc = "Stage Hunk" })
        map("v", "<leader>ghr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, { desc = "Reset Hunk" })
        map("n", "<leader>ghS", gs.stage_buffer, { desc = "Stage Buffer" })
        map("n", "<leader>ghR", gs.reset_buffer, { desc = "Reset Buffer" })
        map("n", "<leader>ghu", gs.undo_stage_hunk, { desc = "Undo Stage Hunk" })
        map("n", "<leader>ghp", gs.preview_hunk, { desc = "Preview Hunk" })
        map("n", "<leader>ghP", gs.preview_hunk_inline, { desc = "Preview Hunk Inline" })
        map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, { desc = "Blame Line" })
        map("n", "<leader>ghB", gs.toggle_current_line_blame, { desc = "Toggle Line Blame" })
        map("n", "<leader>ghd", gs.diffthis, { desc = "Diff This" })
        map("n", "<leader>ghD", function() gs.diffthis("~") end, { desc = "Diff This ~" })
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select Hunk" })
      end,
    },
  },

  -----------------------------------------------------------------------------
  -- TODO-COMMENTS: Highlight and search TODOs
  -----------------------------------------------------------------------------
  {
    "folke/todo-comments.nvim",
    event = "VeryLazy",
    opts = {
      signs = true,
      sign_priority = 8,
      keywords = {
        FIX = { icon = " ", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
        TODO = { icon = " ", color = "info" },
        HACK = { icon = " ", color = "warning" },
        WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
        PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
        NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
        TEST = { icon = " ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
      },
      gui_style = { fg = "NONE", bg = "BOLD" },
      merge_keywords = true,
      highlight = {
        multiline = true,
        multiline_pattern = "^.",
        multiline_context = 10,
        before = "",
        keyword = "wide",
        after = "fg",
        pattern = [[.*<(KEYWORDS)\s*:]],
        comments_only = true,
        max_line_len = 400,
        exclude = {},
      },
      search = {
        command = "rg",
        args = { "--color=never", "--no-heading", "--with-filename", "--line-number", "--column" },
        pattern = [[\b(KEYWORDS):]],
      },
    },
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next Todo" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Prev Todo" },
      { "<leader>xt", "<cmd>Trouble todo toggle<cr>", desc = "Todo (Trouble)" },
      { "<leader>xT", "<cmd>Trouble todo toggle filter = {tag = {TODO,FIX,FIXME}}<cr>", desc = "Todo/Fix/Fixme" },
    },
  },

  -----------------------------------------------------------------------------
  -- PROJECT.NVIM: Project management
  -----------------------------------------------------------------------------
  {
    "ahmedkhalf/project.nvim",
    event = "VeryLazy",
    opts = {
      manual_mode = false,
      detection_methods = { "lsp", "pattern" },
      patterns = {
        ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile",
        "package.json", "go.mod", "pyproject.toml", "Cargo.toml",
        "requirements.txt", "setup.py", "pubspec.yaml", "pom.xml",
      },
      ignore_lsp = {},
      exclude_dirs = { "~/.cargo/*", "*/node_modules/*", "*/.venv/*" },
      show_hidden = false,
      silent_chdir = true,
      scope_chdir = "global",
      datapath = vim.fn.stdpath("data"),
    },
    keys = {
      { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
    },
  },

  -----------------------------------------------------------------------------
  -- MINI.HIPATTERNS: Highlight patterns (colors, todos)
  -----------------------------------------------------------------------------
  {
    "nvim-mini/mini.hipatterns",
    event = "VeryLazy",
    opts = function()
      local hi = require("mini.hipatterns")
      return {
        highlighters = {
          hex_color = hi.gen_highlighter.hex_color({ priority = 2000 }),
          shorthand = {
            pattern = "()#%x%x%x()%f[^%x%w]",
            group = function(_, _, data)
              local match = data.full_match
              local r, g, b = match:sub(2, 2), match:sub(3, 3), match:sub(4, 4)
              local hex = "#" .. r .. r .. g .. g .. b .. b
              return hi.compute_hex_color_group(hex, "bg")
            end,
            extmark_opts = { priority = 2000 },
          },
          fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
          hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
          todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
          note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
        },
      }
    end,
  },

  -----------------------------------------------------------------------------
  -- GH.NVIM: GitHub integration
  -----------------------------------------------------------------------------
  {
    "ldelossa/gh.nvim",
    dependencies = { "ldelossa/litee.nvim" },
    cmd = { "GHOpenIssue", "GHOpenPR", "GHNotifications" },
    config = function()
      require("litee.lib").setup()
      require("litee.gh").setup({
        icon_set = "default",
        git_buffer_completion = true,
        keymaps = {
          open = "<CR>",
          expand = "zo",
          collapse = "zc",
          goto_issue = "gd",
          details = "d",
          submit_comment = "<C-s>",
          actions = "<C-a>",
          resolve_thread = "<C-r>",
          goto_web = "gx",
        },
      })
    end,
    keys = {
      { "<leader>gHi", "<cmd>GHOpenIssue<cr>", desc = "Open Issue" },
      { "<leader>gHo", "<cmd>GHOpenPR<cr>", desc = "Open PR" },
      { "<leader>gHP", "<cmd>GHPreviewPR<cr>", desc = "Preview PR" },
      { "<leader>gHT", "<cmd>GHToggleThreads<cr>", desc = "Toggle Threads" },
      { "<leader>gHn", "<cmd>GHNotifications<cr>", desc = "Notifications" },
    },
  },

  -----------------------------------------------------------------------------
  -- KULALA: REST client
  -----------------------------------------------------------------------------
  {
    "mistweaverco/kulala.nvim",
    ft = "http",
    opts = {
      split_direction = "vertical",
      default_view = "body",
      debug = false,
    },
    keys = {
      { "<leader>Rs", function() require("kulala").run() end, ft = "http", desc = "Send Request" },
      { "<leader>Ra", function() require("kulala").run_all() end, ft = "http", desc = "Send All Requests" },
      { "<leader>Rr", function() require("kulala").replay() end, ft = "http", desc = "Replay Last" },
      { "<leader>Ri", function() require("kulala").inspect() end, ft = "http", desc = "Inspect" },
      { "<leader>Rt", function() require("kulala").toggle_view() end, ft = "http", desc = "Toggle View" },
      { "<leader>Rc", function() require("kulala").copy() end, ft = "http", desc = "Copy as cURL" },
      { "<leader>Rp", function() require("kulala").scratchpad() end, desc = "REST Scratchpad" },
      { "[r", function() require("kulala").jump_prev() end, ft = "http", desc = "Prev Request" },
      { "]r", function() require("kulala").jump_next() end, ft = "http", desc = "Next Request" },
    },
  },

  -----------------------------------------------------------------------------
  -- PERSISTENCE: Session management
  -----------------------------------------------------------------------------
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = { options = vim.opt.sessionoptions:get() },
    keys = {
      { "<leader>qs", function() require("persistence").load() end, desc = "Restore Session" },
      { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
      { "<leader>qd", function() require("persistence").stop() end, desc = "Don't Save Session" },
    },
  },
}
