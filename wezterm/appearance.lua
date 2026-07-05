local wezterm = require("wezterm")

local M = {}

M.apply = function(config)
  config.font = wezterm.font_with_fallback({
    "HackGen Console NF",
    "Noto Sans CJK JP",
    "Hiragino Kaku Gothic ProN",
  })
  config.font_size = 18.0
  config.use_ime = true
  config.window_background_opacity = 0.5
  config.macos_window_background_blur = 20
end

return M
