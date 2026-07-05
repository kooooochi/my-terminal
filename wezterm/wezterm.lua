local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.automatically_reload_config = true

require("appearance").apply(config)
require("tab").apply(config)
require("events").apply()

local is_linux = wezterm.target_triple:find("linux") ~= nil
local keybinds = is_linux and require("keybinds_linux") or require("keybinds")
config.disable_default_key_bindings = true
config.keys = keybinds.keys
config.key_tables = keybinds.key_tables
config.leader = { key = "q", mods = "CTRL", timeout_milliseconds = 2000 }

return config
