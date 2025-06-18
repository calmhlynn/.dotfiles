local wezterm = require("wezterm")
local config = wezterm.config_builder()
local ac = wezterm.action

config.front_end = "WebGpu"
config.font = wezterm.font("Hack Nerd Font Mono")
config.font_size = 15
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
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }

config.disable_default_key_bindings = true

config.keys = {
	{ key = "p", mods = "LEADER", action = ac.SplitHorizontal },

	{ key = "LeftArrow", mods = "LEADER", action = ac.ActivatePaneDirection("Left") },
	{ key = "RightArrow", mods = "LEADER", action = ac.ActivatePaneDirection("Right") },

	{ key = "x", mods = "LEADER", action = ac.CloseCurrentPane({ confirm = true }) },
	{ key = "n", mods = "LEADER", action = ac.SpawnTab("CurrentPaneDomain") },
	{ key = "]", mods = "LEADER", action = ac.ActivateTabRelative(1) },
	{ key = "[", mods = "LEADER", action = ac.ActivateTabRelative(-1) },

	{ key = "w", mods = "LEADER", action = ac.CloseCurrentTab({ confirm = true }) },
	{ key = ";", mods = "LEADER", action = ac.AdjustPaneSize({ "Left", 5 }) },
	{ key = "'", mods = "LEADER", action = ac.AdjustPaneSize({ "Right", 5 }) },
}

for i = 1, 9 do
	table.insert(config.keys, {
		key = tostring(i),
		mods = "LEADER",
		action = ac.ActivateTab(i - 1),
	})
end

config.unix_domains = {
	{
		name = "main",
	},
}

return config
