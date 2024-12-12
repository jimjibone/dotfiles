-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- Colour schemes
--local darkTheme = "Campbell (Gogh)"
local darkTheme = "Hardcore"
local lightTheme = "Catppuccin Latte (Gogh)"
--local lightTheme = "Github Light (Gogh)"
config.color_scheme = darkTheme

-- Condfigure window
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.window_decorations = "RESIZE" -- remove title bar
config.window_padding = {
	left = "0.2cell",
	right = "0.2cell",
	top = "0.1cell",
	bottom = "0.1cell",
}

-- Toggle theme function - activated via keybindings
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

-- Keybindings
local act = wezterm.action
config.keys = {
	-- Toggle between dark and light theme
	{ key = "t", mods = "ALT", action = toggleTheme("color_scheme", darkTheme, lightTheme) },

	-- Switch tabs
	{ key = "LeftArrow", mods = "SHIFT|CTRL", action = act.ActivateTabRelative(-1) },
	{ key = "RightArrow", mods = "SHIFT|CTRL", action = act.ActivateTabRelative(1) },

	-- Fix Home/End keys
	--{ key = "Home", mods = "", action = wezterm.action({ SendString = "\001" }) },
	--{ key = "End", mods = "", action = wezterm.action({ SendString = "\005" }) },
}

-- and finally, return the configuration to wezterm
return config
