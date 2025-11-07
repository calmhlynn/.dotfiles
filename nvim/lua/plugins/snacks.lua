return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		bigfile = {
			enabled = true,
		},
		image = {
			enabled = true,
		},
		input = {
			enabled = true,
		},
		explorer = {
			enabled = true,
		},
		dim = {
			enabled = true,
		},
		indent = {
			enabled = true,
		},
		lazygit = {
			enabled = true,
		},
		notifier = {
			enabled = true,
		},
		toggle = {
			enabled = true,
		},
		zen = {
			enabled = true,
		},
		statuscolumn = {
			enabled = true,
		},
		quickfile = {
			enabled = true,
		},
		picker = {
			enabled = true,
			layout = {
				preset = "default",
				layout = {
					box = "horizontal",
					width = 0.8,
					min_width = 120,
					height = 0.8,
					{
						box = "vertical",
						border = true,
						title = "{title} {live} {flags}",
						{ win = "input", height = 1, border = "bottom" },
						{ win = "list", border = "none" },
					},
					{ win = "preview", title = "{preview}", border = true, width = 0.65 },
				},
			},
			previewers = {
				diff = {
					builtin = false,
					cmd = {
						"delta",
						"--paging=never",
					},
				},
			},
		},
		terminal = {
			enabled = true,
			win = {
				bo = {
					filetype = "terminal",
				},
				wo = {
					winbar = "",
				},
				width = 0.2,
				height = 0.2,
			},
		},

		styles = {
			terminal = {
				keys = {
					q = {
						"<C-q>",
						"<C-\\><C-n>",
						mode = "t",
						expr = true,
						desc = "escape to normal mode",
					},
					term_normal = {
						"<C-t>",
						function()
							Snacks.terminal.toggle()
						end,
						mode = "t",
						expr = true,
						desc = "escape to normal mode",
					},
				},
			},
		},
	},
	keys = {
		{
			"<Space>s",
			function()
				Snacks.explorer()
			end,
			desc = "File Explorer",
		},
		{
			"<C-\\>i",
			function()
				Snacks.input()
			end,
			desc = "Input",
		},
		{
			"<C-\\>lg",
			function()
				Snacks.lazygit()
			end,
			desc = "lazygit",
		},
		{
			"<C-\\>de",
			function()
				Snacks.dim.enable()
			end,
			desc = "dim enable",
		},

		{
			"<C-\\>dd",
			function()
				Snacks.dim.disable()
			end,
			desc = "dim disable",
		},
		{
			"<C-\\>z",
			function()
				Snacks.zen()
			end,
			desc = "zen mode",
		},

		-- picker
		{
			"<C-\\><space>",
			function()
				Snacks.picker.smart()
			end,
			desc = "Smart Find Files",
		},
		{
			"<C-\\>g",
			function()
				Snacks.picker.grep()
			end,
			desc = "Grep",
		},
		{
			"<C-\\>f",
			function()
				Snacks.picker.files()
			end,
			desc = "Find files",
		},
		{
			"<C-\\>b",
			function()
				Snacks.picker.buffers()
			end,
			desc = "Buffers",
		},
		{
			"<C-\\>m",
			function()
				Snacks.picker.man()
			end,
			desc = "Man Pages",
		},
		{

			"<C-\\>h",
			function()
				Snacks.picker.command_history()
			end,
			desc = "Command History",
		},
		{
			"<C-\\>ss",
			function()
				Snacks.picker.lsp_symbols()
			end,
			desc = "LSP Symbols",
		},
		{
			"<C-\\>sS",
			function()
				Snacks.picker.lsp_workspace_symbols()
			end,
			desc = "LSP Workspace Symbols",
		},
		{
			"<C-\\>l",
			function()
				Snacks.picker.lines()
			end,
			desc = "Buffer Lines",
		},
		{
			"<C-\\>n",
			function()
				Snacks.notifier.show_history()
			end,
			desc = "Notification History",
		},
		{
			"@b",
			function()
				Snacks.picker.git_branches()
			end,
			desc = "Git Branches",
		},
		{
			"@l",
			function()
				Snacks.picker.git_log()
			end,
			desc = "Git Log",
		},
		{
			"@L",
			function()
				Snacks.picker.git_log_line()
			end,
			desc = "Git Log Line",
		},
		{
			"@s",
			function()
				Snacks.picker.git_status()
			end,
			desc = "Git Status",
		},
		{
			"@S",
			function()
				Snacks.picker.git_stash()
			end,
			desc = "Git Stash",
		},
		{
			"@d",
			function()
				Snacks.picker.git_diff()
			end,
			desc = "Git Diff (Hunks)",
		},
		{
			"@f",
			function()
				Snacks.picker.git_log_file()
			end,
			desc = "Git Log File",
		},

		{
			"<C-\\>uC",
			function()
				Snacks.picker.colorschemes()
			end,
			desc = "Colorschemes",
		},
		{
			"t",
			function()
				Snacks.terminal.toggle()
			end,
			desc = "Terminal Toggle",
		},
		{
			"gd",
			function()
				Snacks.picker.lsp_definitions()
			end,
			desc = "Goto Definition",
		},
		{
			"gD",
			function()
				Snacks.picker.lsp_declarations()
			end,
			desc = "Goto Declaration",
		},
		{
			"gr",
			function()
				Snacks.picker.lsp_references()
			end,
			nowait = true,
			desc = "References",
		},
		{
			"gI",
			function()
				Snacks.picker.lsp_implementations()
			end,
			desc = "Goto Implementation",
		},
		{
			"gy",
			function()
				Snacks.picker.lsp_type_definitions()
			end,
			desc = "Goto T[y]pe Definition",
		},
		{
			"<C-\\>k",
			function()
				Snacks.picker.keymaps()
			end,
			desc = "Keymaps",
		},

		{
			"<C-\\>j",
			function()
				Snacks.picker.jumps()
			end,
			desc = "Jumps",
		},
	},
}
