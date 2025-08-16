local wezterm = require("wezterm")
local config = wezterm.config_builder()
local ac = wezterm.action

config.front_end = "WebGpu"
config.webgpu_power_preference = "HighPerformance"
config.font = wezterm.font_with_fallback({
	"Hack Nerd Font Mono",
	"Noto Sans Mono CJK KR",
})
config.color_scheme = "Kanagawa Dragon (Gogh)"
config.font_size = 13
config.use_fancy_tab_bar = true
config.window_decorations = "NONE"
config.show_new_tab_button_in_tab_bar = false
config.show_tab_index_in_tab_bar = false
config.adjust_window_size_when_changing_font_size = false

config.inactive_pane_hsb = {
	saturation = 0.6,
	brightness = 0.6,
}

config.window_padding = {
	left = 2,
	right = 2,
	top = 2,
	bottom = 2,
}

config.keys = {
	{ key = "l", mods = "CTRL|SHIFT", action = ac.SplitHorizontal },
	{ key = "m", mods = "CTRL|SHIFT", action = ac.SplitVertical },

	{ key = "x", mods = "CTRL|SHIFT", action = ac.CloseCurrentPane({ confirm = true }) },

	{ key = "n", mods = "CTRL|SHIFT", action = ac.SpawnTab("CurrentPaneDomain") },
	{ key = "t", mods = "CTRL|SHIFT", action = ac.SpawnWindow },

	{ key = "]", mods = "CTRL", action = ac.ActivateTabRelative(1) },
	{ key = "[", mods = "CTRL", action = ac.ActivateTabRelative(-1) },

	{ key = "d", mods = "CTRL|SHIFT", action = ac.ShowDebugOverlay },

	{ key = "w", mods = "CTRL|SHIFT", action = ac.CloseCurrentTab({ confirm = true }) },

	{ key = "LeftArrow", mods = "CTRL|SHIFT", action = ac.AdjustPaneSize({ "Left", 5 }) },
	{ key = "RightArrow", mods = "CTRL|SHIFT", action = ac.AdjustPaneSize({ "Right", 5 }) },
	{ key = "UpArrow", mods = "CTRL|SHIFT", action = ac.AdjustPaneSize({ "Up", 5 }) },
	{ key = "DownArrow", mods = "CTRL|SHIFT", action = ac.AdjustPaneSize({ "Down", 5 }) },

	{ key = "LeftArrow", mods = "CTRL", action = ac.ActivatePaneDirection("Left") },
	{ key = "RightArrow", mods = "CTRL", action = ac.ActivatePaneDirection("Right") },
	{ key = "UpArrow", mods = "CTRL", action = ac.ActivatePaneDirection("Up") },
	{ key = "DownArrow", mods = "CTRL", action = ac.ActivatePaneDirection("Down") },
}

config.unix_domains = {
	{
		name = "wezterm",
	},
}
config.default_gui_startup_args = { "connect", "wezterm" }
config.enable_tab_bar = true
config.use_dead_keys = false

for i = 1, 9 do
	table.insert(config.keys, {
		key = tostring(i),
		mods = "CTRL",
		action = ac.ActivateTab(i - 1),
	})
end
return config
