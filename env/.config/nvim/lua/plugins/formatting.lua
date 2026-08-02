-- Formatting + linting.
--
-- LazyVim's `formatting.prettier` and `lang.typescript.biome` extras already
-- append their formatter to every filetype they support, so this only adds the
-- filetypes nothing else claims — and does it from a function so the extras'
-- entries are extended rather than replaced.
--
-- Keymaps come from LazyVim: <leader>cf format, <leader>cF format injected,
-- <leader>uf / <leader>uF toggle autoformat (buffer / global).

-- Filetypes both prettier and biome claim. Running both is pointless, and
-- biome is the faster, project-scoped one, so it goes first and wins whenever
-- the project actually has a biome config (its require_cwd condition).
local shared = {
  "css",
  "scss",
  "graphql",
  "javascript",
  "javascriptreact",
  "json",
  "jsonc",
  "svelte",
  "typescript",
  "typescriptreact",
  "vue",
  "astro",
}

return {
  {
    "stevearc/conform.nvim",
    ---@param opts conform.setupOpts
    opts = function(_, opts)
      opts.formatters_by_ft = vim.tbl_deep_extend("force", opts.formatters_by_ft or {}, {
        python = { "ruff_format" },
        lua = { "stylua" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        fish = { "fish_indent" },
        php = { "php_cs_fixer" },
        dart = { "dart_format" },
        toml = { "taplo" },
        sql = { "sql_formatter" },
        ["_"] = { "trim_whitespace" },
      })

      for _, ft in ipairs(shared) do
        local list = opts.formatters_by_ft[ft]
        if list then
          table.sort(list, function(a, b)
            return a == "biome-check" and b ~= "biome-check"
          end)
          list.stop_after_first = true
        end
      end

      opts.formatters = opts.formatters or {}
      opts.formatters.shfmt = { prepend_args = { "-i", "2", "-ci", "-bn" } }
      -- Extend, don't replace: the prettier extra owns this table's `condition`.
      opts.formatters.prettier = vim.tbl_extend("force", opts.formatters.prettier or {}, {
        prepend_args = { "--prose-wrap", "always" },
      })
    end,
  },

  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        sh = { "shellcheck" },
        bash = { "shellcheck" },
      },
    },
  },
}
