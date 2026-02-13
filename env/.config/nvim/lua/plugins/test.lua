-- Complete Test configuration with Neotest
-- Covers: test.core
return {
  -----------------------------------------------------------------------------
  -- NEOTEST: Testing framework
  -----------------------------------------------------------------------------
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      -- Adapters
      "nvim-neotest/neotest-python",
      "nvim-neotest/neotest-go",
      "nvim-neotest/neotest-jest",
      "marilari88/neotest-vitest",
      "olimorris/neotest-phpunit",
      "V13Axel/neotest-pest",
    },
    opts = {
      adapters = {
        ["neotest-python"] = {
          dap = { justMyCode = false },
          args = { "--log-level", "DEBUG" },
          runner = "pytest",
          python = function()
            local cwd = vim.fn.getcwd()
            if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
              return cwd .. "/venv/bin/python"
            elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
              return cwd .. "/.venv/bin/python"
            else
              return "python3"
            end
          end,
        },
        ["neotest-go"] = {
          recursive_run = true,
          args = { "-count=1", "-timeout=60s" },
        },
        ["neotest-vitest"] = {
          -- Dynamically find vitest: prefer bun, then local node_modules, then npx
          vitestCommand = function()
            local cwd = vim.fn.getcwd()
            -- Detect bun project (bun.lockb present)
            if vim.fn.filereadable(cwd .. "/bun.lockb") == 1 then
              return "bunx vitest"
            end
            local root = require("neotest-vitest.util").find_node_modules_ancestor(vim.fn.expand("%:p"))
            if root then
              return root .. "/node_modules/.bin/vitest"
            end
            return "npx vitest"
          end,
        },
        ["neotest-jest"] = {
          jestCommand = function()
            local root = require("neotest-jest.jest-util").getJestCommand(vim.fn.expand("%:p:h"))
            return root or "npx jest"
          end,
          jestConfigFile = function(file)
            -- Walk up from file to find nearest jest config
            local dir = vim.fn.fnamemodify(file, ":h")
            while dir ~= "/" do
              for _, name in ipairs({ "jest.config.ts", "jest.config.js", "jest.config.mjs", "jest.config.cjs" }) do
                local config = dir .. "/" .. name
                if vim.fn.filereadable(config) == 1 then
                  return config
                end
              end
              dir = vim.fn.fnamemodify(dir, ":h")
            end
            return vim.fn.getcwd() .. "/jest.config.ts"
          end,
          cwd = function(file)
            -- Use nearest package.json directory as cwd (monorepo support)
            local dir = vim.fn.fnamemodify(file, ":h")
            while dir ~= "/" do
              if vim.fn.filereadable(dir .. "/package.json") == 1 then
                return dir
              end
              dir = vim.fn.fnamemodify(dir, ":h")
            end
            return vim.fn.getcwd()
          end,
          env = { CI = true },
        },
        ["neotest-phpunit"] = {},
        ["neotest-pest"] = {},
      },
      status = {
        virtual_text = true,
        signs = true,
      },
      output = {
        enabled = true,
        open_on_run = "short",
      },
      quickfix = {
        enabled = true,
        open = false,
      },
      summary = {
        animated = true,
        enabled = true,
        expand_errors = true,
        follow = true,
        mappings = {
          attach = "a",
          clear_marked = "M",
          clear_target = "T",
          debug = "d",
          debug_marked = "D",
          expand = { "<CR>", "<2-LeftMouse>" },
          expand_all = "e",
          jumpto = "i",
          mark = "m",
          next_failed = "J",
          output = "o",
          prev_failed = "K",
          run = "r",
          run_marked = "R",
          short = "O",
          stop = "u",
          target = "t",
          watch = "w",
        },
      },
      icons = {
        passed = "✓",
        failed = "✗",
        running = "⟳",
        skipped = "○",
        unknown = "?",
        watching = "👁",
      },
      floating = {
        border = "rounded",
        max_height = 0.6,
        max_width = 0.6,
      },
    },
    config = function(_, opts)
      local neotest = require("neotest")
      local adapters = {}
      for name, config in pairs(opts.adapters or {}) do
        if type(name) == "number" then
          if type(config) == "string" then
            config = require(config)
          end
          adapters[#adapters + 1] = config
        elseif config ~= false then
          local adapter = require(name)
          if type(config) == "table" and not vim.tbl_isempty(config) then
            local meta = getmetatable(adapter)
            if adapter.setup then
              adapter.setup(config)
            elseif meta and meta.__call then
              adapter = adapter(config)
            else
              error("Adapter " .. name .. " does not support configuration")
            end
          end
          adapters[#adapters + 1] = adapter
        end
      end
      opts.adapters = adapters
      neotest.setup(opts)
    end,
    keys = {
      { "<leader>tt", function() require("neotest").run.run() end, desc = "Run Nearest" },
      { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run File" },
      { "<leader>tT", function() require("neotest").run.run(vim.uv.cwd()) end, desc = "Run All Tests" },
      { "<leader>tl", function() require("neotest").run.run_last() end, desc = "Run Last" },
      { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Toggle Summary" },
      { "<leader>to", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Show Output" },
      { "<leader>tO", function() require("neotest").output_panel.toggle() end, desc = "Toggle Output Panel" },
      { "<leader>tS", function() require("neotest").run.stop() end, desc = "Stop" },
      { "<leader>tw", function() require("neotest").watch.toggle(vim.fn.expand("%")) end, desc = "Toggle Watch" },
      { "<leader>td", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "Debug Nearest" },
      { "<leader>tD", function() require("neotest").run.run({ vim.fn.expand("%"), strategy = "dap" }) end, desc = "Debug File" },
      { "[T", function() require("neotest").jump.prev({ status = "failed" }) end, desc = "Prev Failed Test" },
      { "]T", function() require("neotest").jump.next({ status = "failed" }) end, desc = "Next Failed Test" },
    },
  },
}
