return {
	{
		"aznhe21/actions-preview.nvim",
		diff = {
			algorithm = "patience",
			ignore_whitespace = true,
		},
		config = function()
			vim.keymap.set("n", "<leader>ac", function()
				require("actions-preview").code_actions()
			end, bufopts)
		end,
	},
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {},
		dependencies = {
			"MunifTanjim/nui.nvim",
		},
	},
	{
		"lewis6991/hover.nvim",
		config = function()
			require("hover").setup({
				init = function()
					require("hover.providers.lsp")
					require("hover.providers.diagnostic")
				end,
				preview_opts = {
					border = "single",
				},
				-- Whether the contents of a currently open hover window should be moved
				-- to a :h preview-window when pressing the hover keymap.
				preview_window = false,
				title = true,
				mouse_providers = {
					"LSP",
				},
				mouse_delay = 1000,
			})

			-- Setup keymaps
			vim.keymap.set("n", "K", require("hover").hover, { desc = "hover.nvim" })
			vim.keymap.set("n", "gK", require("hover").hover_select, { desc = "hover.nvim (select)" })
			vim.keymap.set("n", "<C-p>", function()
				require("hover").hover_switch("previous")
			end, { desc = "hover.nvim (previous source)" })
			vim.keymap.set("n", "<C-n>", function()
				require("hover").hover_switch("next")
			end, { desc = "hover.nvim (next source)" })

			-- Mouse support
			vim.keymap.set("n", "<MouseMove>", require("hover").hover_mouse, { desc = "hover.nvim (mouse)" })
			vim.o.mousemoveevent = true
		end,
	},
	{ "NvChad/nvim-colorizer.lua", opts = {
		filetypes = { "*" },
	} },
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
	},
	{
		"lewis6991/gitsigns.nvim",
	},
}
