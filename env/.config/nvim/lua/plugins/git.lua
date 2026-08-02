-- Git.
--
-- LazyVim already ships gitsigns with the full ]h / [h / <leader>gh* set and
-- lazygit on <leader>gg, so gitsigns only needs its signs restyled here.
return {
  {
    "lewis6991/gitsigns.nvim",
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
      attach_to_untracked = true,
      current_line_blame_opts = { virt_text_pos = "eol", delay = 500 },
      current_line_blame_formatter = "<author>, <author_time:%R> - <summary>",
      max_file_length = 40000,
    },
  },

  -----------------------------------------------------------------------------
  -- CODEDIFF: side-by-side / inline diffs and file history.
  -- Replaces diffview.nvim, whose last commit was 2024-08. Ships a prebuilt
  -- C library (VS Code's diff algorithm) — no compiler needed, but the first
  -- run downloads it, so give :CodeDiff a second the first time.
  -----------------------------------------------------------------------------
  {
    "esmuellert/codediff.nvim",
    cmd = "CodeDiff",
    keys = {
      { "<leader>gvd", "<cmd>CodeDiff<cr>", desc = "Diff Working Tree" },
      { "<leader>gvs", "<cmd>CodeDiff --staged<cr>", desc = "Diff Staged" },
      { "<leader>gvh", "<cmd>CodeDiff history<cr>", desc = "File History" },
      { "<leader>gvm", "<cmd>CodeDiff main...<cr>", desc = "Diff vs main" },
    },
  },

  -----------------------------------------------------------------------------
  -- GIT-CONFLICT: ]x / [x between conflicts, <leader>gc* to resolve one
  -----------------------------------------------------------------------------
  {
    "akinsho/git-conflict.nvim",
    version = "*",
    event = "VeryLazy",
    opts = {
      default_mappings = false, -- its defaults sit on co/ct/cb/cn and shadow `c` motions
      default_commands = true,
      list_opener = "copen",
      highlights = { incoming = "DiffAdd", current = "DiffText" },
    },
    keys = {
      { "<leader>gco", "<cmd>GitConflictChooseOurs<cr>", desc = "Choose Ours" },
      { "<leader>gct", "<cmd>GitConflictChooseTheirs<cr>", desc = "Choose Theirs" },
      { "<leader>gcb", "<cmd>GitConflictChooseBoth<cr>", desc = "Choose Both" },
      { "<leader>gc0", "<cmd>GitConflictChooseNone<cr>", desc = "Choose None" },
      { "<leader>gcl", "<cmd>GitConflictListQf<cr>", desc = "List Conflicts" },
      { "]x", "<cmd>GitConflictNextConflict<cr>", desc = "Next Conflict" },
      { "[x", "<cmd>GitConflictPrevConflict<cr>", desc = "Prev Conflict" },
    },
  },

  -----------------------------------------------------------------------------
  -- WORKTREES
  -- setup() registers worktrees/worktrees_new/worktrees_remove as snacks picker
  -- sources, which is why Snacks.picker.worktrees() below resolves — the keymap
  -- loads the plugin before calling it.
  -----------------------------------------------------------------------------
  {
    "Juksuu/worktrees.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "GitWorktreeCreate", "GitWorktreeCreateExisting", "GitWorktreeSwitch", "GitWorktreeRemove" },
    opts = { worktree_path = "..", use_netrw = false },
    -- stylua: ignore
    keys = {
      { "<leader>gws", function() Snacks.picker.worktrees() end, desc = "Switch Worktree" },
      { "<leader>gwn", function() Snacks.picker.worktrees_new() end, desc = "New Worktree" },
      { "<leader>gwr", function() Snacks.picker.worktrees_remove() end, desc = "Remove Worktree" },
    },
  },

  -----------------------------------------------------------------------------
  -- OCTO: the LazyVim extra defaults its picker to telescope; we use snacks.
  -----------------------------------------------------------------------------
  {
    "pwntester/octo.nvim",
    optional = true,
    opts = { picker = "snacks" },
  },
}
