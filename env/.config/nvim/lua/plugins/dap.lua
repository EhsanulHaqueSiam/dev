-- Debugging.
--
-- LazyVim's dap.core extra owns the <leader>d* keymaps, the breakpoint signs
-- (themed, via LazyVim.config.icons.dap), dap-ui wiring and — importantly —
-- calls require("mason-nvim-dap").setup() from inside nvim-dap's `config`.
-- Defining a `config` for nvim-dap here would replace that and leave every
-- adapter unregistered, so this file is opts-only.
--
-- Adapters and default launch configs already come from the lang extras:
-- python → nvim-dap-python, go → nvim-dap-go, ts/js → pwa-node/pwa-chrome,
-- lua → dap.nlua, rust/c/cpp → codelldb.
return {
  {
    "mfussenegger/nvim-dap",
    -- stylua: ignore
    keys = {
      { "<F5>",  function() require("dap").continue() end,  desc = "Debug Continue" },
      { "<F10>", function() require("dap").step_over() end, desc = "Debug Step Over" },
      { "<F11>", function() require("dap").step_into() end, desc = "Debug Step Into" },
      { "<F12>", function() require("dap").step_out() end,  desc = "Debug Step Out" },
    },
    -- Extra JS/TS launch configs appended to the ones the typescript extra
    -- registers. Same `opts = function()` side-effect idiom LazyVim uses there.
    opts = function()
      local dap = require("dap")
      for _, lang in ipairs({ "javascript", "typescript", "javascriptreact", "typescriptreact" }) do
        dap.configurations[lang] = dap.configurations[lang] or {}
        vim.list_extend(dap.configurations[lang], {
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch file (bun)",
            runtimeExecutable = "bun",
            program = "${file}",
            cwd = "${workspaceFolder}",
          },
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch test (vitest)",
            runtimeExecutable = "node",
            runtimeArgs = { "./node_modules/.bin/vitest", "run", "${file}" },
            rootPath = "${workspaceFolder}",
            cwd = "${workspaceFolder}",
            console = "integratedTerminal",
          },
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch test (jest)",
            runtimeExecutable = "node",
            runtimeArgs = { "./node_modules/.bin/jest", "--runInBand" },
            rootPath = "${workspaceFolder}",
            cwd = "${workspaceFolder}",
            console = "integratedTerminal",
          },
        })
      end
    end,
  },

  -----------------------------------------------------------------------------
  -- Debuggers to keep installed
  -----------------------------------------------------------------------------
  {
    "jay-babu/mason-nvim-dap.nvim",
    opts = { ensure_installed = { "python", "delve", "js", "codelldb" } },
  },

  -----------------------------------------------------------------------------
  -- DAP UI layout
  -----------------------------------------------------------------------------
  {
    "rcarriga/nvim-dap-ui",
    opts = {
      layouts = {
        {
          elements = {
            { id = "scopes", size = 0.25 },
            { id = "breakpoints", size = 0.25 },
            { id = "stacks", size = 0.25 },
            { id = "watches", size = 0.25 },
          },
          position = "left",
          size = 40,
        },
        {
          elements = {
            { id = "repl", size = 0.5 },
            { id = "console", size = 0.5 },
          },
          position = "bottom",
          size = 10,
        },
      },
    },
  },

  -----------------------------------------------------------------------------
  -- Inline variable values while stopped
  -----------------------------------------------------------------------------
  {
    "theHamsta/nvim-dap-virtual-text",
    opts = {
      highlight_changed_variables = true,
      show_stop_reason = true,
      commented = true,
      only_first_definition = true,
      all_references = false,
      virt_text_pos = "eol",
    },
  },
}
