local wezterm = require("wezterm")
local constants = require("constants")
local commands = require("commands")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- My config choices.
config.initial_cols = 120
config.initial_rows = 28

-- Font settings
config.font_size = 12
config.line_height = 1.2
config.font = wezterm.font("JetBrainsMono Nerd Font")

-- Colors
config.colors = {
  cursor_bg = "white",
  cursor_border = "white",
  background = "#211a12", -- "#292017",
}

-- Overall appearance
config.window_decorations = "RESIZE"
-- config.hide_tab_bar_if_only_one_tab = true -- Setting this will make the window hard to grab
-- config.window_background_image = constants.bg_image
-- config.macos_window_background_blur = 40
-- config.win32_system_backdrop = "Acrylic"
-- config.window_background_opacity = 0.8
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

-- Misc settings
config.max_fps = 120
config.prefer_egl = true

-- Custom commands
wezterm.on("augment-command-palette", function()
  return commands
end)

-- Finally, return the configuration to wezterm:
return config
