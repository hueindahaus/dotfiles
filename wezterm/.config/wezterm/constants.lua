local M = {}

local home_path = os.getenv("HOME") or os.getenv("USERPROFILE")
M.bg_blurred_darker = home_path .. "/.config/wezterm/assets/bg-blurred-darker.png"
M.bg_blurred = home_path .. "/.config/wezterm/assets/bg-blurred.png"
M.bg_image = M.bg_blurred_darker

return M
