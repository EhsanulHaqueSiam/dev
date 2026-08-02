-- Testing.
--
-- The LazyVim test.core extra owns neotest's setup, keymaps (<leader>t*), the
-- trouble consumer and adapter resolution — do NOT add a `config` here, it
-- would replace all of that. Language extras already register their adapters:
-- lang.go → neotest-golang, lang.ruby → neotest-rspec, lang.python →
-- neotest-python, lang.php → neotest-phpunit. This file only adds the
-- JS/TS adapters and per-adapter tuning.
return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "marilari88/neotest-vitest",
      "nvim-neotest/neotest-jest",
    },
    opts = {
      adapters = {
        ["neotest-python"] = {
          dap = { justMyCode = false },
          runner = "pytest",
          python = function()
            local cwd = vim.uv.cwd()
            for _, venv in ipairs({ "/.venv/bin/python", "/venv/bin/python" }) do
              if vim.fn.executable(cwd .. venv) == 1 then
                return cwd .. venv
              end
            end
            return "python3"
          end,
        },

        ["neotest-vitest"] = {
          -- Prefer bun, then a local install, then npx.
          vitestCommand = function()
            local cwd = vim.uv.cwd()
            if vim.fn.filereadable(cwd .. "/bun.lockb") == 1 or vim.fn.filereadable(cwd .. "/bun.lock") == 1 then
              return "bunx vitest"
            end
            local root = require("neotest-vitest.util").find_node_modules_ancestor(vim.fn.expand("%:p"))
            return root and (root .. "/node_modules/.bin/vitest") or "npx vitest"
          end,
        },

        ["neotest-jest"] = {
          jestCommand = function()
            return require("neotest-jest.jest-util").getJestCommand(vim.fn.expand("%:p:h")) or "npx jest"
          end,
          -- Nearest jest config walking up from the test file (monorepo support).
          jestConfigFile = function(file)
            local names = { "jest.config.ts", "jest.config.js", "jest.config.mjs", "jest.config.cjs" }
            local found = vim.fs.find(names, { path = vim.fs.dirname(file), upward = true })[1]
            return found or (vim.uv.cwd() .. "/jest.config.ts")
          end,
          -- Nearest package.json dir as cwd, same reason.
          cwd = function(file)
            local pkg = vim.fs.find("package.json", { path = vim.fs.dirname(file), upward = true })[1]
            return pkg and vim.fs.dirname(pkg) or vim.uv.cwd()
          end,
          env = { CI = true },
        },
      },
      output = { open_on_run = "short" },
      summary = { expand_errors = true, follow = true },
    },
    -- stylua: ignore
    keys = {
      { "<leader>tw", function() require("neotest").watch.toggle(vim.fn.expand("%")) end, desc = "Toggle Watch" },
      { "]T", function() require("neotest").jump.next({ status = "failed" }) end, desc = "Next Failed Test" },
      { "[T", function() require("neotest").jump.prev({ status = "failed" }) end, desc = "Prev Failed Test" },
    },
  },
}
