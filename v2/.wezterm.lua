-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
local darkTheme = "Campbell (Gogh)"
local lightTheme = "Catppuccin Latte"
config.color_scheme = darkTheme
config.use_fancy_tab_bar = false

config.window_padding = {
	left = "0.2cell",
	right = "0.2cell",
	top = "0.0cell",
	bottom = "0.0cell",
}

local function toggleTheme(key, dt, lt)
	return wezterm.action_callback(function(window, pane)
		local o = window:get_config_overrides() or {}
		if o[key] == dt then
			o[key] = lt
		else
			o[key] = dt
		end
		window:set_config_overrides(o)
	end)
end

config.keys = {
	-- Toggle between dark and light theme
	{ key = "t", mods = "ALT", action = toggleTheme("color_scheme", darkTheme, lightTheme) },
}

-- and finally, return the configuration to wezterm
return config
