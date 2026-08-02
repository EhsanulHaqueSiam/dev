-- Coding: completion, pairs, docs, yank.
--
-- blink.cmp, mini.pairs, mini.surround, mini.ai, mini.snippets, ts-comments
-- and nvim-treesitter-textobjects all come from LazyVim / its extras with
-- sensible defaults — nothing to add for them here.
return {
  -----------------------------------------------------------------------------
  -- TS-AUTOTAG: close and rename HTML/JSX tags.
  -- The supported filetype list is built into the plugin; the old `filetypes`
  -- key no longer exists and is silently ignored, so only `opts` is set.
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
    },
  },

  -----------------------------------------------------------------------------
  -- NEOGEN: <leader>cn generates a docstring for the thing under the cursor
  -----------------------------------------------------------------------------
  {
    "danymat/neogen",
    opts = {
      snippet_engine = "mini",
      languages = {
        python = { template = { annotation_convention = "google_docstrings" } },
        javascript = { template = { annotation_convention = "jsdoc" } },
        typescript = { template = { annotation_convention = "tsdoc" } },
        lua = { template = { annotation_convention = "emmylua" } },
        go = { template = { annotation_convention = "godoc" } },
      },
    },
  },

  -----------------------------------------------------------------------------
  -- YANKY: a yank ring behind y/p/P. [y and ]y cycle through it — deliberately
  -- not <C-p>/<C-n>, which belong to the completion menu.
  -----------------------------------------------------------------------------
  {
    "gbprod/yanky.nvim",
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
}
