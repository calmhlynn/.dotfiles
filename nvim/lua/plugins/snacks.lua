-- lua/plugins/snacks.lua
return {

	"folke/snacks.nvim",
	priority = 999,

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
						"<esc>",
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
			"<C-\\>gb",
			function()
				Snacks.picker.git_branches()
			end,
			desc = "Git Branches",
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
			"<C-\\>gl",
			function()
				Snacks.picker.git_log()
			end,
			desc = "Git Log",
		},
		{
			"<C-\\>gL",
			function()
				Snacks.picker.git_log_line()
			end,
			desc = "Git Log Line",
		},
		{
			"<C-\\>gs",
			function()
				Snacks.picker.git_status()
			end,
			desc = "Git Status",
		},
		{
			"<C-\\>gS",
			function()
				Snacks.picker.git_stash()
			end,
			desc = "Git Stash",
		},
		{
			"<C-\\>gd",
			function()
				Snacks.picker.git_diff()
			end,
			desc = "Git Diff (Hunks)",
		},
		{
			"<C-\\>gf",
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
	},
}
