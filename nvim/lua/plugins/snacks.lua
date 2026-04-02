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
			previewers = {
				diff = {
					builtin = false,
					cmd = {
						"delta",
						"--paging=never",
					},
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
			"<C-\\>m",
			function()
				Snacks.picker.man()
			end,
			desc = "Man Pages",
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
			"<C-\\>n",
			function()
				Snacks.notifier.show_history()
			end,
			desc = "Notification History",
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
