-- Theme: follow the current Omarchy theme when there is one, else tokyonight.
--
-- Omarchy 4 moved the current-theme dir from ~/.config/omarchy/current/theme
-- to ~/.local/state/omarchy/current/theme. Check both so this keeps working on
-- either generation (aether.nvim's hotreload watches both paths too).
local omarchy = require("config.omarchy")

local spec = omarchy.theme_spec()
if spec then
  return spec
end

-- Fallback: tokyonight
return {
  { "folke/tokyonight.nvim", priority = 1000 },
  { "LazyVim/LazyVim", opts = { colorscheme = "tokyonight-night" } },
}
