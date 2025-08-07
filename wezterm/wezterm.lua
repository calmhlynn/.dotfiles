local wezterm = require("wezterm")
local config = wezterm.config_builder()
local ac = wezterm.action

config.front_end = "WebGpu"
config.webgpu_power_preference = "HighPerformance"
config.font = wezterm.font_with_fallback({
	"Hack Nerd Font Mono",
	"Noto Sans Mono CJK KR",
})
-- config.color_scheme = "Kanagawa (Gogh)"
config.font_size = 14
config.use_fancy_tab_bar = true
config.window_decorations = "RESIZE"
config.show_new_tab_button_in_tab_bar = false
config.show_tab_index_in_tab_bar = false

config.colors = {
	background = "#181616",
	foreground = "#c5c9c5",

	cursor_bg = "#c5c9c5",
	cursor_fg = "#181616",
	cursor_border = "#c5c9c5",

	selection_bg = "#2d4f67",
	selection_fg = "#c8c093",

	ansi = {
		"#0d0c0c",
		"#c4746e",
		"#8a9a7b",
		"#c4b28a",
		"#8ba4b0",
		"#a292a3",
		"#8ea4a2",
		"#C8C093",
	},

	brights = {
		"#a6a69c",
		"#E46876",
		"#87a987",
		"#E6C384",
		"#7FB4CA",
		"#938AA9",
		"#7AA89F",
		"#c5c9c5",
	},

	indexed = {
		[16] = "#ffa066",
		[17] = "#ff5d62",
	},

	tab_bar = {
		background = "#181616",
		active_tab = {
			bg_color = "#2d4f67",
			fg_color = "#c5c9c5",
		},
		inactive_tab = {
			bg_color = "#181616",
			fg_color = "#a6a69c",
		},
		inactive_tab_hover = {
			bg_color = "#252530",
			fg_color = "#c5c9c5",
		},
		new_tab = {
			bg_color = "#181616",
			fg_color = "#a6a69c",
		},
		new_tab_hover = {
			bg_color = "#252530",
			fg_color = "#c5c9c5",
		},
	},
}

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
