-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- My config choices.
config.initial_cols = 120
config.initial_rows = 28

config.font_size = 19
config.font_height = 1.2
config.font = wezterm.font("JetBrains Mono")
config.color_scheme = "AdventureTime"

-- Finally, return the configuration to wezterm:
return config
