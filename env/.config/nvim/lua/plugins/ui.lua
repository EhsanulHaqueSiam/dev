-- UI plugins configuration
return {
  -----------------------------------------------------------------------------
  -- EDGY: Layout management for sidebars
  -----------------------------------------------------------------------------
  {
    "folke/edgy.nvim",
    event = "VeryLazy",
    opts = {
      animate = { enabled = false },
    },
  },

  -----------------------------------------------------------------------------
  -- WHICH-KEY: Key binding hints
  -----------------------------------------------------------------------------
  {
    "folke/which-key.nvim",
    opts = {
      preset = "modern",
      delay = 300,
      spec = {
        { "<leader>a", group = "ai" },
        { "<leader>b", group = "buffer" },
        { "<leader>c", group = "code" },
        { "<leader>d", group = "debug" },
        { "<leader>f", group = "file/find" },
        { "<leader>g", group = "git" },
        { "<leader>gc", group = "conflict" },
        { "<leader>gh", group = "hunks" },
        { "<leader>gH", group = "github" },
        { "<leader>gv", group = "diffview" },
        { "<leader>h", group = "harpoon" },
        { "<leader>o", group = "overseer" },
        { "<leader>q", group = "quit/session" },
        { "<leader>r", group = "refactor" },
        { "<leader>R", group = "rest" },
        { "<leader>s", group = "search" },
        { "<leader>t", group = "test" },
        { "<leader>u", group = "ui" },
        { "<leader>w", group = "windows" },
        { "<leader>x", group = "diagnostics" },
      },
    },
  },
}
