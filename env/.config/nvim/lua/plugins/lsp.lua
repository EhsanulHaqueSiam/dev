-- LSP configuration.
--
-- Deliberately small: LazyVim's lang extras (typescript/vtsls, json, yaml,
-- tailwind, python, go, rust, ...) already configure their servers, including
-- inlay hints, schemastore wiring and filetype lists. Only servers that no
-- extra covers, or that need a machine-specific tweak, belong here.
return {
  {
    "folke/neoconf.nvim",
    opts = {},
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- LazyVim binds <leader>ca as a *buffer-local* LSP keymap, which wins
        -- over tiny-code-action's global one in every LSP buffer. Drop it.
        ["*"] = { keys = { { "<leader>ca", false } } },

        -- Ruby: use the mise-managed ruby-lsp on PATH (writable gem home),
        -- NOT Mason's (hardcoded to system ruby's read-only gem home).
        -- mason=false keeps it enabled but skips the broken Mason install.
        ruby_lsp = { mason = false },

        ruff = {
          init_options = {
            settings = { fixAll = true, organizeImports = true },
          },
        },

        pyright = {
          settings = {
            python = {
              analysis = {
                autoImportCompletions = true,
                autoSearchPaths = true,
                diagnosticMode = "openFilesOnly",
                useLibraryCodeForTypes = true,
                typeCheckingMode = "basic",
              },
            },
          },
        },

        svelte = {
          settings = {
            svelte = {
              plugin = {
                html = { completions = { enable = true, emmet = true } },
                css = { completions = { enable = true, emmet = true } },
                svelte = { completions = { enable = true } },
              },
            },
          },
        },

        emmet_ls = {
          filetypes = {
            "html",
            "css",
            "scss",
            "javascriptreact",
            "typescriptreact",
            "svelte",
            "vue",
          },
        },

        marksman = {},
        cssls = {},
        html = {},
        bashls = {},
      },
      inlay_hints = { enabled = true },
      codelens = { enabled = true },
      document_highlight = { enabled = true },
      -- tiny-inline-diagnostic renders these instead; leaving both on
      -- double-prints every diagnostic.
      diagnostics = { virtual_text = false },
    },
  },

  -----------------------------------------------------------------------------
  -- TINY-INLINE-DIAGNOSTIC: the diagnostic for the current line, rendered next
  -- to it without reflowing the buffer (which 0.11's virtual_lines does).
  -----------------------------------------------------------------------------
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy",
    priority = 1000,
    opts = {
      preset = "modern",
      options = {
        show_source = { enabled = true, if_many = true },
        multilines = { enabled = true, always_show = false },
        show_all_diags_on_cursorline = false,
      },
    },
  },

  -----------------------------------------------------------------------------
  -- TINY-CODE-ACTION: preview each code action as a diff before applying it.
  -- `backend = "vim"` needs nothing extra; switch to "delta" if you install
  -- git-delta.
  -----------------------------------------------------------------------------
  {
    "rachartier/tiny-code-action.nvim",
    dependencies = { "folke/snacks.nvim" },
    event = "LspAttach",
    opts = { backend = "vim", picker = "snacks" },
    -- stylua: ignore
    keys = {
      { "<leader>ca", function() require("tiny-code-action").code_action() end, mode = { "n", "x" }, desc = "Code Action" },
    },
  },

  -----------------------------------------------------------------------------
  -- TROUBLE: extra lists on top of LazyVim's <leader>xx / <leader>xX.
  -- <leader>cs stays LazyVim's Outline, <leader>cS its LSP references.
  -----------------------------------------------------------------------------
  {
    "folke/trouble.nvim",
    opts = {
      auto_close = true,
      auto_preview = true,
      auto_refresh = true,
      focus = true,
      modes = {
        lsp = { win = { position = "right" } },
        diagnostics = { auto_open = false },
      },
    },
    -- stylua: ignore
    keys = {
      { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },
      { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)" },
    },
  },

  -----------------------------------------------------------------------------
  -- MASON
  -- The custom `config` fixes a LazyVim race: its default calls p:install()
  -- without checking p:is_installing(), which throws when mason's config runs
  -- twice (startup + first file open). Verified still present in LazyVim 16.
  -----------------------------------------------------------------------------
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "prettier",
        "biome",
        "eslint_d",
        "shellcheck",
        "markdownlint",
        "debugpy",
        "js-debug-adapter",
      },
      ui = {
        width = 0.8,
        height = 0.8,
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")
      mr:on("package:install:success", function()
        vim.defer_fn(function()
          require("lazy.core.handler.event").trigger({
            event = "FileType",
            buf = vim.api.nvim_get_current_buf(),
          })
        end, 100)
      end)
      mr.refresh(function()
        for _, tool in ipairs(opts.ensure_installed) do
          local ok, p = pcall(mr.get_package, tool)
          if ok and not p:is_installed() and not p:is_installing() then
            p:install()
          end
        end
      end)
    end,
  },

  -----------------------------------------------------------------------------
  -- TREESITTER
  -- Only `ensure_installed` is merged here (opts_extend). `auto_install` and
  -- `incremental_selection` are no-ops on the main branch — highlight/indent/
  -- folds are LazyVim's own keys and are already enabled by default.
  -----------------------------------------------------------------------------
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "css",
        "dart",
        "dockerfile",
        "git_config",
        "git_rebase",
        "gitattributes",
        "gitcommit",
        "gitignore",
        "http",
        "hyprlang",
        "json5",
        "scss",
        "sql",
        "svelte",
      },
    },
  },
}
