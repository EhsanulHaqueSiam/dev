-- Omarchy integration.
--
-- Omarchy ships a lazy.nvim spec per theme at <theme>/neovim.lua and symlinks
-- the active one under a "current/theme" directory. Omarchy 3 put that under
-- ~/.config/omarchy, Omarchy 4 moved it to ~/.local/state/omarchy — support
-- both, newest first.
local M = {}

M.theme_dirs = {
  vim.fn.expand("~/.local/state/omarchy/current/theme"), -- Omarchy 4+
  vim.fn.expand("~/.config/omarchy/current/theme"), -- Omarchy 3
}

-- Where themes are installed. A user copy in ~/.config wins over the system
-- one, same precedence as `omarchy-theme-dir`.
M.theme_roots = {
  vim.fn.expand("~/.config/omarchy/themes"),
  vim.fn.expand("~/.local/share/omarchy/themes"),
}

--- Path of the active theme's neovim.lua, or nil when Omarchy isn't installed
--- (or the active theme ships no Neovim spec — several of them don't).
---@return string?
function M.theme_file()
  for _, dir in ipairs(M.theme_dirs) do
    local file = dir .. "/neovim.lua"
    if vim.fn.filereadable(file) == 1 then
      return file
    end
  end
end

--- The active theme's lazy.nvim spec.
---@return table?
function M.theme_spec()
  local file = M.theme_file()
  if not file then
    return nil
  end
  local ok, spec = pcall(dofile, file)
  return ok and type(spec) == "table" and spec or nil
end

-- The omarchy-nvim package's own pre-install list. It covers themes that ship
-- only colors.toml (they get an aether spec rendered from a template at
-- theme-set time) plus a few plugins no installed theme references yet.
M.shipped_stub_file = "/usr/share/omarchy-nvim/config/lua/plugins/all-themes.lua"

--- Every colorscheme plugin any installed Omarchy theme can ask for, as lazy
--- stubs. Switching themes rewrites current/theme; the new colorscheme has to
--- already be on disk for the hot reload to have anything to load, and lazy
--- only installs what the spec tree mentions at startup.
---
--- Scanned from the themes on disk (plus omarchy-nvim's shipped list) rather
--- than hand-maintained, so it stays correct across Omarchy updates.
---@return table
function M.colorscheme_stubs()
  local names, repos, stubs = {}, {}, {}

  -- Track both the resolved plugin name and the repo: lazy keys plugins by
  -- name but collapses two names pointing at one URL, and Omarchy pins aether
  -- under different names *and* branches across themes.
  local function claim(repo, name)
    names[name or repo:match("[^/]+$")] = true
    repos[repo] = true
  end

  local function add(plugin)
    local repo = plugin[1]
    if type(repo) ~= "string" or repo == "LazyVim/LazyVim" then
      return
    end
    if names[plugin.name or repo:match("[^/]+$")] or repos[repo] then
      return
    end
    claim(repo, plugin.name)
    stubs[#stubs + 1] = {
      repo,
      name = plugin.name,
      branch = plugin.branch,
      version = plugin.version,
      lazy = true,
      priority = 1000,
    }
  end

  -- The active theme declares its own colorscheme over in plugins/theme.lua,
  -- with the name and branch that theme wants. Never stub the same repo — the
  -- two declarations would race and whichever lost would take the branch pin
  -- with it.
  for _, plugin in ipairs(M.theme_spec() or {}) do
    if type(plugin) == "table" and type(plugin[1]) == "string" then
      claim(plugin[1], plugin.name)
    end
  end

  local function scan(file)
    if vim.fn.filereadable(file) ~= 1 then
      return
    end
    local ok, spec = pcall(dofile, file)
    if not (ok and type(spec) == "table") then
      return
    end
    for _, plugin in ipairs(spec) do
      if type(plugin) == "table" then
        add(plugin)
        for _, dep in ipairs(plugin.dependencies or {}) do
          add(type(dep) == "string" and { dep } or dep)
        end
      end
    end
  end

  -- Themes first: their specs carry the name/branch pins that matter.
  for _, root in ipairs(M.theme_roots) do
    for _, dir in ipairs(vim.fn.glob(root .. "/*", false, true)) do
      scan(dir .. "/neovim.lua")
    end
  end
  scan(M.shipped_stub_file)

  return stubs
end

return M
