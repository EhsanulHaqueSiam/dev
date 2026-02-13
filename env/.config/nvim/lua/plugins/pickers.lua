-- Picker plugins configuration
-- snacks_picker and snacks_explorer handle everything via LazyVim extras
-- Only custom overrides here
return {
  -----------------------------------------------------------------------------
  -- TODO-COMMENTS: Picker integration via Snacks
  -----------------------------------------------------------------------------
  {
    "folke/todo-comments.nvim",
    keys = {
      { "<leader>st", function() Snacks.picker.todo_comments() end, desc = "Todo" },
      { "<leader>sT", function() Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } }) end, desc = "Todo/Fix/Fixme" },
    },
  },
}
