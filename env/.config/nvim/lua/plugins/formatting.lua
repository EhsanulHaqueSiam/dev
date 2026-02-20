-- Complete Formatting configuration
-- Covers: biome, black, prettier, conform.nvim, none-ls
return {
  -----------------------------------------------------------------------------
  -- CONFORM.NVIM: Formatting
  -----------------------------------------------------------------------------
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    opts = {
      formatters_by_ft = {
        -- Web
        javascript = { "biome", "prettier", stop_after_first = true },
        javascriptreact = { "biome", "prettier", stop_after_first = true },
        typescript = { "biome", "prettier", stop_after_first = true },
        typescriptreact = { "biome", "prettier", stop_after_first = true },
        svelte = { "prettier" },
        vue = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
        json = { "biome", "prettier", stop_after_first = true },
        jsonc = { "biome", "prettier", stop_after_first = true },
        yaml = { "prettier" },
        -- Python (ruff handles both linting and formatting, no need for black)
        python = { "ruff_format" },
        -- Go (requires `go` to be installed: yay -S go)
        -- go = { "goimports", "gofumpt" },
        -- Markdown (markdownlint is a linter, handled by nvim-lint)
        markdown = { "prettier" },
        ["markdown.mdx"] = { "prettier" },
        -- Lua
        lua = { "stylua" },
        -- Shell
        sh = { "shfmt" },
        bash = { "shfmt" },
        fish = { "fish_indent" },
        -- PHP
        php = { "php_cs_fixer" },
        -- Dart
        dart = { "dart_format" },
        -- Docker
        dockerfile = {},
        -- TOML
        toml = { "taplo" },
        -- SQL
        sql = { "sql_formatter" },
        -- GraphQL
        graphql = { "prettier" },
        -- General
        ["_"] = { "trim_whitespace" },
      },
      -- format_on_save handled by LazyVim automatically
      formatters = {
        shfmt = {
          prepend_args = { "-i", "2", "-ci", "-bn" },
        },
        prettier = {
          prepend_args = { "--prose-wrap", "always" },
        },
        biome = {
          require_cwd = true,
        },
      },
    },
    keys = {
      { "<leader>cf", function() require("conform").format({ async = true, lsp_fallback = true }) end, mode = { "n", "v" }, desc = "Format" },
      { "<leader>cF", function() require("conform").format({ formatters = { "injected" }, timeout_ms = 3000 }) end, mode = { "n", "v" }, desc = "Format Injected" },
      { "<leader>uf", function()
        if vim.b.disable_autoformat then
          vim.b.disable_autoformat = false
          vim.notify("Autoformat enabled (buffer)")
        else
          vim.b.disable_autoformat = true
          vim.notify("Autoformat disabled (buffer)")
        end
      end, desc = "Toggle Autoformat (buffer)" },
      { "<leader>uF", function()
        if vim.g.disable_autoformat then
          vim.g.disable_autoformat = false
          vim.notify("Autoformat enabled (global)")
        else
          vim.g.disable_autoformat = true
          vim.notify("Autoformat disabled (global)")
        end
      end, desc = "Toggle Autoformat (global)" },
    },
    init = function()
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
  },

  -----------------------------------------------------------------------------
  -- NONE-LS: Additional linting/formatting sources
  -----------------------------------------------------------------------------
  {
    "nvimtools/none-ls.nvim",
    dependencies = { "mason.nvim" },
    opts = function(_, opts)
      local nls = require("null-ls")
      opts.root_dir = opts.root_dir
        or require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git")
      opts.sources = vim.list_extend(opts.sources or {}, {
        -- Diagnostics
        nls.builtins.diagnostics.markdownlint,
        -- Code actions
        nls.builtins.code_actions.gitsigns,
      })
    end,
  },

  -----------------------------------------------------------------------------
  -- NVIM-LINT: Additional linting
  -----------------------------------------------------------------------------
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        markdown = { "markdownlint" },
        sh = { "shellcheck" },
        bash = { "shellcheck" },
      },
    },
  },
}
