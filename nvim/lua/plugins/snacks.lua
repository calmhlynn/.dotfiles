return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	config = function(_, opts)
		require("snacks").setup(opts)

		vim.api.nvim_create_autocmd("QuitPre", {
			group = vim.api.nvim_create_augroup("snacks_auto_quit", { clear = true }),
			desc = "Close snacks windows before quitting so :q exits cleanly",
			callback = function()
				local snacks_windows = {}
				local floating_windows = {}
				local windows = vim.api.nvim_list_wins()
				for _, w in ipairs(windows) do
					local filetype = vim.api.nvim_get_option_value("filetype", { buf = vim.api.nvim_win_get_buf(w) })
					if filetype:match("snacks_") ~= nil then
						table.insert(snacks_windows, w)
					elseif vim.api.nvim_win_get_config(w).relative ~= "" then
						table.insert(floating_windows, w)
					end
				end
				if 1 == #windows - #floating_windows - #snacks_windows then
					for _, w in ipairs(snacks_windows) do
						vim.api.nvim_win_close(w, true)
					end
				end
			end,
		})
	end,
	opts = {
		explorer = {
			enabled = true,
		},
		bigfile = {
			enabled = true,
		},
		indent = {
			enabled = true,
		},
		notifier = {
			enabled = true,
		},
		toggle = {
			enabled = true,
		},
		quickfile = {
			enabled = true,
		},
		picker = {
			enabled = true,
			layout = {
				preset = "default",
			},
			layouts = {
				default = {
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
						{ win = "preview", title = "{preview}", border = true, width = 0.6 },
					},
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
			sources = {
				git_log = {
					preview = "git_log",
				},
			},
			actions = {
				sidekick_send = function(...)
					return require("sidekick.cli.picker.snacks").send(...)
				end,
			},
			win = {
				input = {
					keys = {
						["<a-a>"] = {
							"sidekick_send",
							mode = { "n", "i" },
						},
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
		-- picker
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
			"<C-\\>F",
			function()
				Snacks.picker.files({
					hidden = true,
					ignored = true,
					follow = true,
					exclude = {
						".git",
						".git/*",
					},
				})
			end,
			desc = "Find all files (no gitignore)",
		},
		{
			"<C-\\>b",
			function()
				Snacks.picker.buffers()
			end,
			desc = "Buffers",
		},
		{
			"<C-\\>h",
			function()
				Snacks.picker.command_history()
			end,
			desc = "Command History",
		},
		{
			"<C-\\>H",
			function()
				Snacks.picker.recent()
			end,
			desc = "Recent Files",
		},
		{
			"<C-\\>/",
			function()
				Snacks.picker.search_history()
			end,
			desc = "Search History",
		},
		{
			"<C-\\>l",
			function()
				Snacks.picker.lines()
			end,
			desc = "Buffer Lines",
		},
		{
			"<C-\\>:",
			function()
				Snacks.picker.commands()
			end,
			desc = "Commands",
		},
		{
			"<C-\\>m",
			function()
				Snacks.picker.man()
			end,
			desc = "Man Pages",
		},
		{
			"<C-\\>S",
			function()
				Snacks.picker.lsp_symbols()
			end,
			desc = "LSP Symbols",
		},
		{
			"<C-\\>s",
			function()
				Snacks.picker.lsp_workspace_symbols()
			end,
			desc = "LSP Workspace Symbols",
		},
		{
			"<C-\\>n",
			function()
				Snacks.picker.notifications()
			end,
			desc = "Notification History",
		},
		{
			"<C-\\>uC",
			function()
				Snacks.picker.colorschemes()
			end,
			desc = "Colorschemes",
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
		{
			"<C-\\>gs",
			function()
				Snacks.picker.git_status()
			end,
			desc = "Git Status Files",
		},
		{
			"<C-\\>d",
			function()
				Snacks.picker.git_diff()
			end,
			desc = "Git Diff (Hunks)",
		},
		{
			"<C-\\>c",
			function()
				Snacks.picker.git_log()
			end,
			desc = "Git Log",
		},
		{
			"<C-\\>lf",
			function()
				Snacks.picker.git_log_file()
			end,
			desc = "Git Log File",
		},
		{
			"t",
			function()
				Snacks.terminal.toggle()
			end,
			desc = "Terminal Toggle",
		},
		{
			"gr",
			function()
				Snacks.picker.lsp_references()
			end,
			desc = "References",
		},
	},
}
