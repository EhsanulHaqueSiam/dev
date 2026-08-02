-- Pre-install (but don't load) every colorscheme any installed Omarchy theme
-- can select, so switching themes hot-reloads instead of failing on a plugin
-- that isn't cloned yet.
--
-- Built from the themes on disk — see lua/config/omarchy.lua.
return require("config.omarchy").colorscheme_stubs()
