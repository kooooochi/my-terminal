local wezterm = require("wezterm")

local M = {}

M.apply = function()
  ----------------------------------------------------
  -- Claude Code Notification Handler
  ----------------------------------------------------
  -- OSC 1337 SetUserVar で受け取り、toast_notification で表示する
  wezterm.on("user-var-changed", function(window, pane, name, value)
    if name == "claude_code_notify" then
      -- OSC 1337 経由の値は base64 エンコードされている
      local decoded = wezterm.base64_decode(value)
      local title, message = string.match(decoded, "([^|]+)|(.+)")
      if title and message and window then
        wezterm.log_info(string.format("[Claude Code] %s: %s", title, message))
        window:toast_notification("Claude Code", title, message, 3000)
      end
    end
  end)
end

return M
