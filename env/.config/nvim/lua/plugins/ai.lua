-- AI plugins configuration
-- Copilot + blink.cmp integration + CopilotChat
return {
  -----------------------------------------------------------------------------
  -- COPILOT.LUA: GitHub Copilot
  -- Suggestion mode DISABLED - blink.cmp handles completion via blink-cmp-copilot
  -----------------------------------------------------------------------------
  {
    "zbirenbaum/copilot.lua",
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
      filetypes = {
        markdown = true,
        help = false,
        gitcommit = true,
        gitrebase = false,
        yaml = true,
        ["."] = false,
      },
    },
  },

  -----------------------------------------------------------------------------
  -- BLINK-COPILOT: Copilot source for blink.cmp (fang2hou/blink-copilot)
  -----------------------------------------------------------------------------
  {
    "fang2hou/blink-copilot",
    dependencies = { "zbirenbaum/copilot.lua" },
  },

  -----------------------------------------------------------------------------
  -- BLINK.CMP: Add copilot as completion source
  -----------------------------------------------------------------------------
  {
    "saghen/blink.cmp",
    optional = true,
    dependencies = { "fang2hou/blink-copilot" },
    opts = {
      sources = {
        default = { "copilot", "lsp", "path", "snippets", "buffer" },
        providers = {
          copilot = {
            name = "copilot",
            module = "blink-copilot",
            score_offset = 100,
            async = true,
          },
        },
      },
    },
  },

  -----------------------------------------------------------------------------
  -- COPILOT-CHAT: AI Chat with Copilot
  -----------------------------------------------------------------------------
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "main",
    dependencies = {
      { "zbirenbaum/copilot.lua" },
      { "nvim-lua/plenary.nvim" },
    },
    build = "make tiktoken",
    opts = {
      model = "gpt-4o",
      auto_follow_cursor = true,
      show_help = true,
      question_header = "## User ",
      answer_header = "## Copilot ",
      error_header = "## Error ",
      window = {
        layout = "vertical",
        width = 0.4,
        border = "rounded",
      },
      mappings = {
        complete = { insert = "<Tab>" },
        close = { normal = "q", insert = "<C-c>" },
        reset = { normal = "<C-l>", insert = "<C-l>" },
        submit_prompt = { normal = "<CR>", insert = "<C-s>" },
        accept_diff = { normal = "<C-y>", insert = "<C-y>" },
        show_diff = { normal = "gd" },
        show_info = { normal = "gi" },
        show_context = { normal = "gc" },
      },
    },
    keys = {
      { "<leader>aa", "<cmd>CopilotChatToggle<cr>", desc = "Toggle Chat" },
      { "<leader>ae", "<cmd>CopilotChatExplain<cr>", mode = { "n", "v" }, desc = "Explain Code" },
      { "<leader>ar", "<cmd>CopilotChatReview<cr>", mode = { "n", "v" }, desc = "Review Code" },
      { "<leader>af", "<cmd>CopilotChatFix<cr>", mode = { "n", "v" }, desc = "Fix Code" },
      { "<leader>ao", "<cmd>CopilotChatOptimize<cr>", mode = { "n", "v" }, desc = "Optimize Code" },
      { "<leader>ad", "<cmd>CopilotChatDocs<cr>", mode = { "n", "v" }, desc = "Generate Docs" },
      { "<leader>at", "<cmd>CopilotChatTests<cr>", mode = { "n", "v" }, desc = "Generate Tests" },
      { "<leader>aD", "<cmd>CopilotChatDebugInfo<cr>", desc = "Debug Info" },
      { "<leader>am", "<cmd>CopilotChatCommit<cr>", desc = "Commit Message" },
      { "<leader>aq", function()
        local input = vim.fn.input("Quick Chat: ")
        if input ~= "" then
          require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
        end
      end, desc = "Quick Chat" },
      { "<leader>ax", "<cmd>CopilotChatReset<cr>", desc = "Reset Chat" },
    },
  },
}
