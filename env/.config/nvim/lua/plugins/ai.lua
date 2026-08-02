-- AI.
--
-- Stack (see lazyvim.json):
--   ai.copilot-native — inline completion through Neovim 0.12's native
--     vim.lsp.inline_completion, driven by copilot-language-server. Replaces
--     copilot.lua + the unmaintained blink-copilot source.
--   ai.sidekick       — Copilot next-edit-suggestions (<tab>) plus an AI CLI
--     panel that runs the real `claude` binary. Owns <leader>a.
--   ai.copilot-chat   — in-editor chat, moved to <leader>A to make room.
--
-- ai.copilot and ai.copilot-native are mutually exclusive; the native extra
-- errors out if both are enabled.
return {
  -----------------------------------------------------------------------------
  -- SIDEKICK
  -----------------------------------------------------------------------------
  {
    "folke/sidekick.nvim",
    opts = {
      cli = {
        -- Keep CLI sessions alive across :q when Neovim is already inside tmux.
        mux = { backend = "tmux", enabled = vim.env.TMUX ~= nil },
      },
    },
  },

  -----------------------------------------------------------------------------
  -- COPILOT CHAT
  -- Rehomed to <leader>A: sidekick's extra claims <leader>a and they collided
  -- on aa/ad/af/at/ap/ax.
  -----------------------------------------------------------------------------
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    opts = {
      -- `model` is deliberately unset — the old "gpt-4o" pin is retired and
      -- CopilotChat's own default tracks whatever Copilot currently serves.
      -- `:CopilotChatModels` lists what your subscription can use.
      auto_follow_cursor = true,
      show_help = true,
      -- Replaced the old question_header / answer_header / error_header trio.
      headers = {
        user = "## User ",
        assistant = "## Copilot ",
        tool = "## Tool ",
      },
      window = { layout = "vertical", width = 0.4 },
      mappings = {
        complete = { insert = "<Tab>" },
        close = { normal = "q", insert = "<C-c>" },
        reset = { normal = "<C-l>", insert = "<C-l>" },
        submit_prompt = { normal = "<CR>", insert = "<C-s>" },
        accept_diff = { normal = "<C-y>", insert = "<C-y>" },
        show_diff = { normal = "gd" },
        show_info = { normal = "gi" },
      },
    },
    -- stylua: ignore
    keys = {
      -- drop the extra's <leader>a* bindings; sidekick owns that prefix
      { "<leader>aa", false },
      { "<leader>ax", false },
      { "<leader>aq", false },
      { "<leader>ap", false },

      { "<leader>A", "", desc = "+copilot chat", mode = { "n", "v" } },
      { "<leader>AA", "<cmd>CopilotChatToggle<cr>", desc = "Toggle Chat" },
      { "<leader>Ae", "<cmd>CopilotChatExplain<cr>", mode = { "n", "v" }, desc = "Explain Code" },
      { "<leader>Ar", "<cmd>CopilotChatReview<cr>", mode = { "n", "v" }, desc = "Review Code" },
      { "<leader>Af", "<cmd>CopilotChatFix<cr>", mode = { "n", "v" }, desc = "Fix Code" },
      { "<leader>Ao", "<cmd>CopilotChatOptimize<cr>", mode = { "n", "v" }, desc = "Optimize Code" },
      { "<leader>Ad", "<cmd>CopilotChatDocs<cr>", mode = { "n", "v" }, desc = "Generate Docs" },
      { "<leader>At", "<cmd>CopilotChatTests<cr>", mode = { "n", "v" }, desc = "Generate Tests" },
      { "<leader>Am", "<cmd>CopilotChatCommit<cr>", desc = "Commit Message" },
      { "<leader>Ap", function() require("CopilotChat").select_prompt() end, mode = { "n", "v" }, desc = "Prompt Actions" },
      { "<leader>Ax", "<cmd>CopilotChatReset<cr>", desc = "Reset Chat" },
      { "<leader>Aq", function()
          local input = vim.fn.input("Quick Chat: ")
          if input ~= "" then
            require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
          end
        end, desc = "Quick Chat" },
    },
  },
}
