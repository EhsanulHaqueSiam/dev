-- Complete LSP configuration
-- MAXIMUM AUTOMATION: LSP attaches automatically, formats on save, auto-imports
return {
  -----------------------------------------------------------------------------
  -- NEOCONF: Project-local settings
  -- AUTOMATED: Loads .neoconf.json automatically
  -----------------------------------------------------------------------------
  {
    "folke/neoconf.nvim",
    opts = {},
  },

  -----------------------------------------------------------------------------
  -- NVIM-LSPCONFIG: LSP configuration
  -- AUTOMATED: Auto-attach, auto-format, auto-import, inlay hints
  -----------------------------------------------------------------------------
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Lua
        lua_ls = {
          settings = {
            Lua = {
              workspace = { checkThirdParty = false },
              codeLens = { enable = true },
              completion = { callSnippet = "Replace" },
              doc = { privateName = { "^_" } },
              hint = {
                enable = true,
                setType = false,
                paramType = true,
                paramName = "Disable",
                semicolon = "Disable",
                arrayIndex = "Disable",
              },
            },
          },
        },
        -- Python
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
        ruff = {
          init_options = {
            settings = {
              fixAll = true,
              organizeImports = true,
            },
          },
        },
        -- Go
        gopls = {
          settings = {
            gopls = {
              gofumpt = true,
              codelenses = {
                gc_details = false,
                generate = true,
                regenerate_cgo = true,
                run_govulncheck = true,
                test = true,
                tidy = true,
                upgrade_dependency = true,
                vendor = true,
              },
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
              analyses = {
                fieldalignment = true,
                nilness = true,
                unusedparams = true,
                unusedwrite = true,
                useany = true,
              },
              usePlaceholders = true,
              completeUnimported = true,
              staticcheck = true,
              directoryFilters = { "-.git", "-.vscode", "-.idea", "-.venv", "-node_modules" },
              semanticTokens = true,
            },
          },
        },
        -- TypeScript
        ts_ls = {
          settings = {
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayVariableTypeHintsWhenTypeMatchesName = false,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
              suggest = {
                includeCompletionsForModuleExports = true,
                includeAutomaticOptionalChainCompletions = true,
              },
              updateImportsOnFileMove = { enabled = "always" },
            },
            javascript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
              suggest = {
                includeCompletionsForModuleExports = true,
                includeAutomaticOptionalChainCompletions = true,
              },
              updateImportsOnFileMove = { enabled = "always" },
            },
          },
        },
        -- JSON
        jsonls = {
          settings = {
            json = {
              schemas = require("schemastore").json.schemas(),
              validate = { enable = true },
            },
          },
        },
        -- YAML
        yamlls = {
          settings = {
            yaml = {
              schemaStore = { enable = false, url = "" },
              schemas = require("schemastore").yaml.schemas(),
            },
          },
        },
        -- Svelte
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
        -- Other servers with defaults
        taplo = {},
        marksman = {},
        dockerls = {},
        docker_compose_language_service = {},
        cssls = {},
        html = {},
        tailwindcss = {
          filetypes = { "html", "css", "scss", "javascript", "javascriptreact", "typescript", "typescriptreact", "svelte", "vue" },
        },
        emmet_ls = {
          filetypes = { "html", "css", "scss", "javascript", "javascriptreact", "typescript", "typescriptreact", "svelte", "vue" },
        },
        bashls = {},
      },
      inlay_hints = { enabled = true },
      codelens = { enabled = true },
      document_highlight = { enabled = true },
      capabilities = {
        textDocument = {
          foldingRange = { dynamicRegistration = false, lineFoldingOnly = true },
        },
      },
    },
  },

  -----------------------------------------------------------------------------
  -- TROUBLE: Diagnostics list
  -- AUTOMATED: Updates automatically, integrates with quickfix
  -----------------------------------------------------------------------------
  {
    "folke/trouble.nvim",
    opts = {
      auto_close = true, -- Auto-close when no more items
      auto_open = false,
      auto_preview = true,
      auto_refresh = true, -- Auto-refresh on changes
      focus = true,
      modes = {
        lsp = { win = { position = "right" } },
        diagnostics = { auto_open = false }, -- Don't auto-open diagnostics
      },
    },
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics" },
      { "<leader>cs", "<cmd>Trouble symbols toggle<cr>", desc = "Symbols" },
      { "<leader>cS", "<cmd>Trouble lsp toggle<cr>", desc = "LSP References" },
      { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List" },
      { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix" },
      { "[q", function()
        if require("trouble").is_open() then
          require("trouble").prev({ skip_groups = true, jump = true })
        else
          pcall(vim.cmd.cprev)
        end
      end, desc = "Previous Item" },
      { "]q", function()
        if require("trouble").is_open() then
          require("trouble").next({ skip_groups = true, jump = true })
        else
          pcall(vim.cmd.cnext)
        end
      end, desc = "Next Item" },
    },
  },

  -----------------------------------------------------------------------------
  -- MASON: Auto-install LSP/DAP/Linters
  -- AUTOMATED: Installs tools automatically
  -----------------------------------------------------------------------------
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        -- LSP servers
        "lua-language-server",
        "pyright",
        "ruff",
        "gopls",
        "typescript-language-server",
        "svelte-language-server",
        "tailwindcss-language-server",
        "json-lsp",
        "yaml-language-server",
        "taplo",
        "marksman",
        "dockerfile-language-server",
        "docker-compose-language-service",
        "html-lsp",
        "css-lsp",
        "emmet-ls",
        "bash-language-server",
        -- Formatters
        "stylua",
        "prettier",
        "ruff",
        "shfmt",
        "biome",
        "gofumpt",
        "goimports",
        -- Linters
        "eslint_d",
        "shellcheck",
        "markdownlint",
        "golangci-lint",
        -- DAP
        "debugpy",
        "js-debug-adapter",
        "delve",
      },
      ui = {
        border = "rounded",
        width = 0.8,
        height = 0.8,
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },

  -----------------------------------------------------------------------------
  -- TREESITTER: Syntax parsing
  -- AUTOMATED: Auto-installs parsers, auto-highlights
  -----------------------------------------------------------------------------
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = vim.list_extend(opts.ensure_installed or {}, {
        "bash", "c", "css", "dart", "diff", "dockerfile", "git_config",
        "git_rebase", "gitattributes", "gitcommit", "gitignore", "go",
        "gomod", "gosum", "gowork", "html", "http", "javascript", "jsdoc",
        "json", "json5", "jsonc", "lua", "luadoc", "luap", "markdown",
        "markdown_inline", "python", "query", "regex", "scss", "sql",
        "svelte", "toml", "tsx", "typescript", "vim", "vimdoc", "xml", "yaml",
      })
      opts.auto_install = true -- Auto-install missing parsers
      opts.highlight = { enable = true }
      opts.indent = { enable = true }
      opts.incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      }
    end,
  },

  -----------------------------------------------------------------------------
  -- LSP AUTO-FORMAT: Format on save
  -- Already configured in formatting.lua, this ensures LSP fallback
  -----------------------------------------------------------------------------

  -----------------------------------------------------------------------------
  -- SCHEMASTORE: JSON/YAML schemas
  -- AUTOMATED: Provides schemas automatically
  -----------------------------------------------------------------------------
  {
    "b0o/schemastore.nvim",
    lazy = true,
  },
}
